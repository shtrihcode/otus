mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
mdadm --create --verbose /dev/md1 -l 6 -n 5 /dev/sd{b,c,d,e,f}
mkdir /etc/mdadm
touch /etc/mdadm/mdadm.conf
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf 
mdadm --detail --scan --verbose | awk '/ARRAY/{print}' >> /etc/mdadm/mdadm.conf 