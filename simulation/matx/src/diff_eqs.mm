Matrix u;
Func Matrix diff_eqs_nonliner(t, xx, u)
Real t;
Matrix xx, u;
{
  Matrix K;
  Matrix xxdot, z;
  Matrix tmp, tmp2, tmp3;
  Real a, m, M, g, l, f, c, J;
  Real k;

  a = 0.49;
  m = 0.038;
  M = 1.51;
  g = 9.8;
  l = 0.12;
  f = 16.5;
  c = 9.82e-5;
  J = 3.9e-4;
  k = 2500;

  u = k*(0.1 - xx(1));


  K=[[ M+m,           m*l*cos(xx(2)) ]
     [ m*l*cos(xx(2)),    J+m*l*l    ]];

  xxdot = [ [ xx(3) ]
            [ xx(4) ]
            [
             (K~ * [[ a*u(1) + m*l*sin(xx(2)) * xx(4)^2 - f*xx(3) ]
                    [           m*g*l*sin(xx(2)) - c*xx(4)          ]])
            ]
          ];


/*
  K=[[ M+m,           m*l ]
     [ m*l,    J+m*l^2    ]];

  print K;

  xxdot = [ [ xx(3) ]
            [ xx(4) ]
            [
             (K~ * [[ a*u(1) + m*l*xx(2) * xx(4)^2 - f*xx(3) ]
                    [           m*g*l*xx(2) - c*xx(4)          ]])
            ]
          ];
*/
  return xxdot;
}

Func Matrix diff_eqs_liner_under(t, xx, u)
Real t;
Matrix xx, u;
{
  Matrix K, _K, A, B;
  Matrix tmp, tmp2, tmp3;
  Matrix xxdot;
  Real a, m, M, g, l, f, c, J;

  a = 0.49;
  m = 0.038;
  M = 1.00;
  g = 9.8;
  l = 0.12;
  f = 9.67;
  c = 9.8e-5;
  J = 3.9e-4;

  u = [13.0];

  K = [[ M+m,      -m*l   ]
     [ -m*l,    J+m*l^2 ]];

  print K;

  /** inv(K) */
  _K = K~;

  tmp = _K*[[ 0,    0    ]
          [ 0,  -m*g*l ]];

  tmp2 = _K*[[ -f,   0  ]
           [  0,   -c ]];

  A = [[ Z(2,2) I(2,2) ]
       [ tmp    tmp2   ]];
   print A;

  tmp3 = _K*[[a] [0]];
  B = trans([0 0 tmp3(1) tmp3(2)]);
  print B;

  xxdot = A*xx + B*u;

  return xxdot;
}

Func void main()
{
  Real t0,t1,h;
  Matrix x0,T,X;
  Matrix data;

  x0=trans([0 0 0 0]);
  t0=0.0;
  t1=10.0;
  h=0.01;

  // print diff_eqs_nonliner(1,x0,[0]);

  {T,X}=Ode(t0,t1,x0,diff_eqs_liner_under,"",h);
/*
  read data << "restep13.mat";

  mgplot(1,T,X,{"r","th","dr","dth"});
  mgreplot(1,data(1,:),data(3,:));
  mgplot_eps(1,"nonliner.eps");
*/
}
