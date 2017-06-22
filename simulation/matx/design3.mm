read <- "params";
Real r, th, dr, dth;
Matrix  A, B, C, F, K, Ah, Bh, Ch, Dh, Jh;
Matrix Ahd, Bhd, Jhd, Hhd;
Matrix z;
CoMatrix obs_p;

Func void init()
{
  Matrix  A21, A22, B2;
  CoMatrix pc;

  K = [[M+m ,m*l]
       [m*l, J+m*l^2]];

  A21=K\[[0, 0][0, m*g*l]];
  A22=K\[[-f, 0][0, -c]];
  A  = [[Z(2,2), I(2,2)]
       [ A21   , A22   ]];
  B2=K\[[a][0]];
  B  = trans([Z(1,2),trans(B2)]);

  C = [[c1 0 0 0 ][0 c2 0 0]];

  pc = [(-10,0), (-10,0), (-5,0), (-5,0)]';
  F  = pplace(A, B, pc);

  obs_p = trans([(-2,0), (-2,0)]);
  read obs_p;

}

Func Matrix link_eqs_discretion(t, x)
Matrix x;
Real t;
{
  Matrix xp, xh, u, y, xref;

  xp = x(1:4,1);    // 倒立振子の状態
  z = x(5:6,1);     // オブザーバの状態

  // 台車の可動範囲に関する制限
	if (x(1,1) <= -0.16 || 0.16 <= x(1,1)) { // r = x(1,1)
    //OdeStop();	             // シミュレーションを停止
  }

  y = C*xp;

  xh = Ch*z + Dh*y;
  if(t <= 5){
    xref = [0 0 0 0]';
  }
  else if(t <= 10){
    xref = [0.1 0 0 0]';
	}
  else if(t <= 15){
    xref = [0 0 0 0]';
  }

  u = F * (xref - xh);

  // 入力の大きさに関する制限
  if (u(1,1) <= -15) {
      u(1,1) = -15;
  } else if (u(1,1) >= 15) {
      u(1,1) = 15;
  }

  z = Ahd*z + Bhd*y + Jhd*u; // オブザーバの状態の更新

  return u;
}


Func Matrix diff_eqs_discretion(t,x,u)
Real t;
Matrix x,u;
{
  Matrix xp, y, dx, dxp, dz;

  xp = x(1:4,1);    // 倒立振子の状態
  //z = x(5:6,1);     // オブザーバの状態
  y = C*xp;         // 出力の計算

  r = xp(1,1);
  th = xp(2,1);
  dr = xp(3,1);
  dth = xp(4,1);

  K = [[M+m ,m*l*cos(th)]
       [m*l*cos(th), J+m*l^2]];

  A = [[-f*dr + m*l*sin(th)*dth^2+a*u(1,1)]
       [m*g*l*sin(th) - c*dth]];
  B = K\A;

  dxp = trans([dr dth B(1,1) B(2,1)]); // 倒立振子の状態の微分(非線形モデル)
  dz = Ah*z + Bh*y + Jh*u; // オブザーバの状態の微分
  dx = [[dxp][dz]];
  return dx;
}

Func void main()
{

  Real t0, t1, r0 ,th0, tol, dt, dtsav;
  Matrix xp0, z0, x0, T, X, U;

  t0 = 0.0;
  t1 = 15.0;
  r0 = 0.0;
  th0 = 0.0;
  xp0 = [r0 th0/180*PI 0 0]';
  z0 = [0 0]';
  x0 = [[xp0][z0]];
  dt = 0.005; // サンプリング周期
  dtsav = 0.05; // データ保存間隔
  tol = 1.0E-14;

  init();
  {Ah, Bh, Ch, Dh, Jh} = obsg(A, B, C, obs_p);
  {Ahd, Hhd} = c2d(Ah, [Bh Jh], dt);
  Bhd = Hhd(:,1:2);
  Jhd = Hhd(:,3);

  {T, X, U} = Ode45Auto(t0, t1, x0, diff_eqs_discretion, link_eqs_discretion, tol, dtsav);

  mgplot(1, T, X(1:2,:), {"r","th"});
  mgplot(2, T, U, {"u"});
}
