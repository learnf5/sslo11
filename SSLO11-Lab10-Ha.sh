# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
ucs1=sslo1_ha.ucs
ucs2=sslo2_ha.ucs
#curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/sslo1_prep_ha.ucs     --output /tmp/sslo1_prep_ha.ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/sslo1_ha.ucs     --output /tmp/sslo1_ha.ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/sslo1_ha_L3.ucs     --output /tmp/sslo1_ha_L3.ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/sslo2_prep_ha.ucs     --output /tmp/sslo2_prep_ha.ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/sslo2_ha.ucs     --output /tmp/sslo2_ha.ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/sslo2_ha_L3.ucs     --output /tmp/sslo2_ha_L3.ucs

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
for i in {1..30}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo1
sudo scp /tmp/sslo1_*.ucs 192.168.1.31:/var/local/ucs
sudo ssh 192.168.1.31 tmsh load sys ucs sslo1_prep_ha.ucs no-license

#prepare sslo2
sudo scp /tmp/sslo2_*.ucs 192.168.2.31:/var/local/ucs
sudo ssh 192.168.2.31 tmsh load sys ucs sslo2_prep_ha.ucs no-license

# update Student Workstation
touch /tmp/lab10

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
for i in {1..30}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# Rename virtual server in base config
sudo ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value true
sudo ssh root@192.168.1.31 tmsh mv ltm virtual existing_app_pool existing_app_vs
sudo ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value false
sudo ssh root@192.168.1.31 tmsh save /sys config

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

set +x
