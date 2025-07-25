sleep 1
clear
echo "--------------------------------Starting Link---------------------------------"
iwctl station wlan0 scan
sleep 3
iwctl station wlan0 get-networks
echo -n "Enter Network: "
read  nid
iwctl station wlan0 connect $nid
echo "Linked"
