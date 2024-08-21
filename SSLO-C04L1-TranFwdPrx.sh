# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
ucs=sslo1_cert.ucs
curl --silent https://raw.githubusercontent.com/learnf5/sslo/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx
curl --silent https://raw.githubusercontent.com/learnf5/sslo/main/ucs/$ucs     --output /tmp/$ucs

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

#prepare sslo1
sudo scp /tmp/$ucs 192.168.1.31:/var/local/ucs
sudo ssh 192.168.1.31 tmsh load sys ucs $ucs no-license

# update Student Workstation
touch /tmp/lab4.1
sudo ip route change default via 172.16.1.33

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
