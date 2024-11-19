# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
ucs1=sslo1_base.ucs
ucs2=sslo2_base.ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/sslo/main/ucs/$ucs1     --output /tmp/$ucs1
curl --silent https://raw.githubusercontent.com/learnf5/sslo/main/ucs/$ucs2     --output /tmp/$ucs2
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/bigip.license.sslo1     --output /tmp/bigip.license.sslo1
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/bigip.license.sslo2     --output /tmp/bigip.license.sslo2

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "NO LICENSE" ] && break; sleep 5; done

# install license on sslo1
sudo scp /tmp/bigip.license.sslo1 192.168.1.31:/config/bigip.license
sudo ssh 192.168.1.31 reloadlic

# confirm sslo2 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "NO LICENSE" ] && break; sleep 5; done

# install license on sslo2
sudo scp /tmp/bigip.license.sslo2 192.168.2.31:/config/bigip.license
sudo ssh 192.168.2.31 reloadlic

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo1
sudo scp /tmp/$ucs1 192.168.1.31:/var/local/ucs
sudo ssh 192.168.1.31 tmsh load sys ucs $ucs1 no-license

# confirm sslo2 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo2
sudo scp /tmp/$ucs2 192.168.2.31:/var/local/ucs
sudo ssh 192.168.2.31 tmsh load sys ucs $ucs2 no-license

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# confirm sslo2 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# update Student Workstation
touch /tmp/lab1
sudo ip route change default via 172.16.1.33
