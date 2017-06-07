Func Matrix vdpol(t,x,u)
Real t;
Matrix x,u;
{
Real m,l,J,c,a,c1,c2,g;
Real th1,th2;
Matrix dth;

m = 0.038;
l = 0.12;
J = 3.7e-4;
c = 7.34e-5;
g = 9.8;

th1 = x(1,1);
th2 = x(2,1);

u = [0.0];

dth = [[- c * th1 / (J + m * l * l) - m * g * l * th2 / (J + m * l *l ) ]
      [                          th1                                  ]];

return dth;
}


Func void main()
{
Matrix X,T,x0;
Real t0,t1,h,dth0;
Matrix vdpol();
Matrix data;
read data << "drop.mat";
dth0 = -0.01;
x0=[PI-2.90754400E+00 ,dth0]';
t0 = 0.0;
t1 = 10.0;
h =  0.01;
{T,X} = Ode(t0,t1,x0,vdpol,"",h);
mgplot(1,T,X(1,:),{"th"});
mgreplot(1,data(1,:),data(4,:) .+ PI);
}
