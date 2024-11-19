# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
ucs=sslo1_tls13.ucs
scf=swg_profile.scf
#curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/ucs/$ucs --output /tmp/$ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/scf/$scf --output /tmp/$scf

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo1
sudo scp /tmp/$ucs 192.168.1.31:/var/local/ucs
sudo scp /tmp/$scf 192.168.1.31:/var/local/scf
sudo ssh 192.168.1.31 tmsh load sys ucs $ucs no-license

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# provision APM
sudo ssh 192.168.1.31 tmsh modify sys provision apm level minimum

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# merge in swg_profile configs
sudo ssh 192.168.1.31 tmsh load sys config merge file $scf

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# create SWG_Profile
sudo ssh 192.168.1.31 tmsh modify /apm profile access SWG_Profile generation-action increment
sudo ssh 192.168.1.31 tmsh save sys config
#sudo ssh 192.168.1.31 reboot

# update Student Workstation
touch /tmp/lab8

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

set +x
