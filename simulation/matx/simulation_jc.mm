/*---------- solver func ----------*/
Func Matrix vdpol(t,x,u)
/* argments declarations */
Real t;
Matrix x,u;
{
  /* local declarations */
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
    th1 = x(1);
    th2 = x(2);

    /* operating differential */
    dth = [[                        th2                        ]
           [  - c*th2 / (J + m*l*l) - m*g*l*th1 / (J + m*l*l)  ]];

    return dth;
}
/*-------------- end --------------*/

/*---------- --main func ----------*/
Func void main()
{
    /* local declaration */
    Matrix X,T,x0;
    Real t0,t1,h,dth0;
    Matrix data;
    Matrix sim;

    /* plot process */
    read data << "maemaemae.mat";
    dth0 = 0.1;
    x0=[PI + data(4,1),dth0]';
    t0 = 0.0;
    t1 = 5.0;
    h =  0.01;
    {T,X} = Ode(t0,t1,x0,vdpol,"",h);
    X(1,:) = X(1,:) .- PI;
    print [[T][X]] >> "freePend.mat";
    //print [[data(1,:)][data(4,:)]] >> "takitakitaki.mat";
    // mgplot(1,T,X(1,:),{"sim_th"});
    // mgreplot(1,data(1,:),data(4,:), {"actual_th"});
    // mgplot_grid(1);
    // mgplot_xlabel(1,"t[s]");
    // mgplot_ylabel(1,"th[rad]");
}
