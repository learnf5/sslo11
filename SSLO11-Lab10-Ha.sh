# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
ucs1=sslo1_ha.ucs
ucs2=sslo2_ha.ucs
#curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/$ucs1     --output /tmp/$ucs1
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/$ucs2     --output /tmp/$ucs2

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
for i in {1..30}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo1
sudo scp /tmp/$ucs1 192.168.1.31:/var/local/ucs
sudo ssh 192.168.1.31 tmsh load sys ucs $ucs1 no-license

#prepare sslo2
sudo scp /tmp/$ucs2 192.168.2.31:/var/local/ucs
sudo ssh 192.168.2.31 tmsh load sys ucs $ucs2 no-license

# update Student Workstation
touch /tmp/lab10

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
for i in {1..30}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

set +x
