/*---------- solver func ----------*/
Func Matrix vdpol(t,x,u)
/* argments declaration */
Real t;
Matrix x,u;
{
  /* local declaration */
    Real m,l,J,c,a,c1,c2,g;
    Real th1,th2;
    Matrix dth;

    /* variations to be changed */
    J = 3.9e-4;
    c = 9.8e-5;

    /* constant variations */
    m = 0.038;
    l = 0.12;
    g = 9.8;
    u = [0.0];

    /* trans to matrix operation */
    th1 = x(1,1);
    th2 = x(2,1);

    /* operating differential */
    dth = [[- c * th1 / (J + m * l * l) - m * g * l * th2 / (J + m * l *l ) ]
          [                          th1                                  ]];

    return dth;
}
/*-------------- end --------------*/

/*---------- --main func ----------*/
Func void main()
{
    /* local declaration */
    Matrix X,T,x0;
    Real t0,t1,h,dth0;
    Matrix vdpol();
    Matrix data;

    /* plot process */
    read data << "maemaemae.mat";
    dth0 = 0.00;
    x0=[PI+data(4,1) ,dth0]';
    t0 = 0.0;
    t1 = 5.0;
    h =  0.01;
    {T,X} = Ode(t0,t1,x0,vdpol,"",h);
    mgplot(1,T,X(1,:),{"th"});
    mgreplot(1,data(1,:),data(4,:) .+ PI);
}
