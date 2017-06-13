Real m;
Real l;
Real f;
Real M;
Real f;
Real J;
Real c;
Real a;
Real c1;
Real c2;
Real g;
Matrix A;
Matrix B;
Matrix F;
Matrix K;
Matrix A21;
Matrix A22;
Matrix B2;

Func Matrix link_eqs_pole(t, x)
Matrix x;
Real t;
{
    Matrix u, xref;

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

Func Matrix diff_eqs_linear(t,x,u)
Real t;
Matrix x,u;
{
  u = [0.0];
  return A*x + B*u;
}

Func void main()
{

  Real t0, t1, r0 ,th0, tol;
  Matrix link_eqs_pole(), diff_eqs_linear();
  Matrix x0, T, X, U;
  CoMatrix pc;

  m = 0.038;
  l = 0.12;
  M = 1.001;
  f = 9.67;
  J = 3.9e-4;
  c = 9.82e-5;
  a = 0.49;
  c1 = 1.0;
  c2 = 1.0;
  g = 9.8;

  t0 = 0.0;
  t1 = 5.0;
  r0 = 0.0;
  th0 = 10.0;
  x0 = [r0 th0/180*PI 0 0]';
  tol = 1.0E-8;

  K = [[M+m ,-m*l]
       [-m*l, J+m*l^2]];

  A21=K\[[0 0][0, -m*g*l]];
  A22=K\[[-f, 0][0, -c]];
  A=Z(4);
  A(1,2,A21)=I(2);
  A(2,1,A21)=A21;
  A(2,2,A22)=A22;

  B2=K\[[a][0]];
  B=[0 0 B2(1,1) B2(2,1)]';

  pc = [(-6,0), (-8,0), (-8,0), (-10,0)]';
  F  = pplace(A, B, pc);

{T, X, U} = Ode45Auto(t0, t1, x0, diff_eqs_linear, link_eqs_pole, tol);

mgplot(1, T, X, {"r","th","dr","dth"});
}
