echo -n "Choose Number from 1-10: "
read num
echo $num

if [[ $num -lt 1 || $num -gt 10 ]]; then
    echo "Invalid number..."
else
    for i in $num; do
        echo $i
    done



fi