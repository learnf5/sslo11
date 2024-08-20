# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

# update Student Workstation
touch /tmp/lab1
sudo ip route change default via 172.16.1.33
