echo "\

------------------ parameter will be changed --------------------\

"

matx design3.mm

echo "\

------------------ parameter was changed --------------------\

"

echo "\

------------------ make start --------------------\

"

if [ $? == 0 ]; then
    make clean;
    make;
fi

echo "\

------------------ make end --------------------\

"

echo "\

------------------ simulation start --------------------\





















"

if [ $? == 0 ]; then
    sudo ./sample
fi

echo "\

----------------- sample end ---------------------\


"