# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
ucs=sslo1_tf_proxy.ucs
#curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/$ucs     --output /tmp/$ucs

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo1
sudo scp /tmp/$ucs 192.168.1.31:/var/local/ucs
sudo ssh 192.168.1.31 tmsh load sys ucs $ucs no-license

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# Rename virtual server in base config
sudo ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value true
sudo ssh root@192.168.1.31 tmsh mv ltm virtual existing_app_pool existing_app_vs
sudo ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value false
sudo ssh root@192.168.1.31 tmsh save /sys config

# update Student Workstation
touch /tmp/lab5

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

set +x
