# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
ucs1=sslo1_ex_app.ucs
ucs2=sslo1_id_comp.ucs
#curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/$ucs1     --output /tmp/$ucs1
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/$ucs2     --output /tmp/$ucs2

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo1
sudo scp /tmp/$ucs1 192.168.1.31:/var/local/ucs
sudo scp /tmp/$ucs2 192.168.1.31:/var/local/ucs
sudo ssh 192.168.1.31 tmsh load sys ucs $ucs1 no-license

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# Rename virtual server in base config
sudo ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value true
sudo ssh root@192.168.1.31 tmsh mv ltm virtual existing_app_pool existing_app_vs
sudo ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value false
sudo ssh root@192.168.1.31 tmsh save /sys config

# update Student Workstation
touch /tmp/lab7

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

 set +x
