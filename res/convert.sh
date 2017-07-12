read -sp "password: " pass;

for name in `ls | grep -v $0`; do
    name=$(echo $name | sed 's/\.png//g');
    echo $pass | sudo -S convert $name.png $name.eps;
done
