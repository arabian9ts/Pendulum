Func void main()
{
  Matrix data;
  read data << "ref_data/pp2.mat";
  print [[data(1,:)][data(3:4,:)]] >> "case1.mat";
}
