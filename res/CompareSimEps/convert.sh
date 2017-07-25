read -sp "password: " pass;

for name in *.eps; do
    name=$(echo $name | sed 's/\.eps//g');
    echo $pass | sudo -S convert $name.eps $name.png;
done
