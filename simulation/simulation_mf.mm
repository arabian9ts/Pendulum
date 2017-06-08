/*---------- solver func ----------*/
Func Matrix vdpol(t,x,u)
/* argments declarations */
Real t;
Matrix x,u;
{
    /* local declarations */
    Real M,f,l,a,c1,c2,g;
    Real r1,r2;
    Matrix dr;

    /* variations to be changed */
    M = 1.001;
    f = 9.67;
    u = [13.0];

    /* constant variations */
    a = 0.49;
    g = 9.8;

    /* trans to matrix operation */
    r1 = x(1);
    r2 = x(2);

    /* operating differential */
    dr = [[        r2         ]
          [ a*u(1)/M - f*r2/M ]];

    return dr;
}
/*-------------- end --------------*/

/*---------- --main func ----------*/
Func void main()
{
    /* local declaration */
    Matrix X,T,x0;
    Real t0,t1,h;
    Matrix data;

    /* plot process */
    read data << "restep13.mat";
    x0=[0 0]';
    t0 = 0.0;
    t1 = 0.5;
    h =  0.01;
    {T,X} = Ode(t0,t1,x0,vdpol,"",h);
    mgplot(1,T,X(1,:),{"dr"});
    mgreplot(1,data(1,:),data(3,:));
}
