Func void main()
{
  Matrix data;
  read data << "pp.mat";
  mgplot(1,data(1,:),data(3:5,:),{"r", "th", "ref"});
  mgplot_grid(1);
  mgplot(2,data(1,:),data(2,:),{"u"});
  mgplot_grid(2);
}
