Func void main()
{
  Matrix K, _K, A, B, C;
  Matrix tmp, tmp2, tmp3;
  Matrix Nc, No;
  Real a, m, M, g, l, f, c, J;

  a = 0.49;
  m = 0.038;
  M = 1.00;
  g = 9.8;
  l = 0.12;
  f = 9.67;
  c = 9.8e-5;
  J = 3.9e-4;

  K = [[ M+m,      -m*l   ]
     [ -m*l,    J+m*l^2 ]];

  /** inv(K) */
  _K = K~;

  C = [[1, 0, 0, 0][0, 1, 0, 0]];

  tmp = _K*[[ 0,    0    ]
          [ 0,  -m*g*l ]];

  tmp2 = _K*[[ -f,   0  ]
           [  0,   -c ]];

  A = [[ Z(2,2) I(2,2) ]
       [ tmp    tmp2   ]];

  tmp3 = _K*[[a] [0]];
  B = trans([0 0 tmp3(1) tmp3(2)]);

  Nc = [B, A*B, A^2*B A^3*B];
  No = [[C][C*A][C*A^2][C*A^3]];

  print(eigval(A));
  print(rank(Nc));
  print(rank(No));

}
