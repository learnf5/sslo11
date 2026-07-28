# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

# update Student Workstation
touch /tmp/lab1

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# disable debugging
set +x
