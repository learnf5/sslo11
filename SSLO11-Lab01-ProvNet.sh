# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

# update Student Workstation
touch /tmp/lab1

# Rename virtual server in base config
ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value true
ssh root@192.168.1.31 tmsh mv ltm virtual existing_app_pool existing_app_vs
ssh root@192.168.1.31 tmsh modify /sys db mcpd.mvenabled value false
ssh root@192.168.1.31 tmsh save /sys config

# confirm bigip1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# disable debugging
set +x
