read <- "params";
Matrix F;


Func void init()
{
  Matrix K, A21, A22, B2, A, B;
  CoMatrix pc;

  K = [[M+m ,m*l]
       [m*l, J+m*l^2]];

  A21=K\[[0, 0][0, m*g*l]];
  A22=K\[[-f, 0][0, -c]];
  A  = [[Z(2,2), I(2,2)]
       [ A21   , A22   ]];
  B2=K\[[a][0]];
  B  = trans([Z(1,2),trans(B2)]);

  pc = [(-10,0), (-10,0), (-5,0), (-5,0)]';
  F  = pplace(A, B, pc);
  read F;
}

Func Matrix link_eqs_pole(t, x)
Matrix x;
Real t;
{
  Matrix A, B, u, xref;

  // 台車の可動範囲に関する制限
	if (x(1,1) <= -0.16 || 0.16 <= x(1,1)) { // r = x(1,1)
        OdeStop();	                         // シミュレーションを停止
  }

  xref = [0 0 0 0]';
  u = F * (xref - x);

  // 入力の大きさに関する制限
  if (u(1,1) <= -15) {
      u(1,1) = -15;
  } else if (u(1,1) >= 15) {
      u(1,1) = 15;
  }

  return u;
}


Func Matrix diff_eqs_pole(t,x,u)
Real t;
Matrix x,u;
{
  Real r, th, dr, dth;
  Matrix dx, K;
  r = x(1,1);
  th = x(2,1);
  dr = x(3,1);
  dth = x(4,1);

  K = [[M+m ,m*l*cos(th)]
       [m*l*cos(th), J+m*l^2]];

  A = [[-f*dr + m*l*sin(th)*dth^2+a*u(1,1)]
       [m*g*l*sin(th) - c*dth]];
  B = K\A;
  dx = [dr dth B(1,1) B(2,1)]';
  return dx;
}

Func void main()
{

  Real t0, t1, r0 ,th0, tol;
  Matrix x0, T, X, U;

  t0 = 0.0;
  t1 = 3.0;
  r0 = 0.0;
  th0 = 10.0;
  x0 = [r0 th0/180*PI 0 0]';
  tol = 1.0E-8;

  init();

  {T, X, U} = Ode45Auto(t0, t1, x0, diff_eqs_pole, link_eqs_pole, tol);

  mgplot(1, T, X, {"r","th","dr","dth"});
  mgreplot(1, T, U, {"u"});
}
