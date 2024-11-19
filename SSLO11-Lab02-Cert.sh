# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

#Download needed files
mkdir /home/student/Desktop/Lab_Files
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/certs/RootCertAndKey.pfx --output /home/student/Desktop/Lab_Files/RootCertAndKey.pfx

# update Student Workstation
touch /tmp/lab2

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

set +x
