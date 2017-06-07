Func Matrix vdpol(t,x,u)
Real t;
Matrix x,u;
{
Real M,f,l,a,c1,c2,g;
Real r1,r2;
Matrix dr;

M = 1.02;
f = 9.78;
a = 0.49;
g = 9.8;

r1 = x(1,1);
r2 = x(2,1);

u = [11.0];

dr = [[a*u(1)/M - f*r1/M ]
      [        r1        ]];

return dr;
}


Func void main()
{
Matrix X,T,x0;
Real t0,t1,h;
Matrix vdpol();
Matrix data;1
read data << "step_11.mat";
x0=[0 0]';
t0 = 0.0;
t1 = ;
h =  0.01;
{T,X} = Ode(t0,t1,x0,vdpol,"",h);
mgplot(1,T,X(2,:),{"r"});
mgreplot(1,data(1,:),data(3,:));
}
