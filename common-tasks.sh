# enable debugging
set -x
PS4='+$(date +"%T.%3N"): '

# add copy-paste file on desktop
curl --silent https://raw.githubusercontent.com/learnf5/sslo/main/sslo_v9.3_copy_paste.txt --output /home/student/Desktop/Copy-Paste.txt

# run this lab's specific tasks saved on GitHub
curl --silent --output /tmp/$LAB_ID.sh https://raw.githubusercontent.com/learnf5/$COURSE_ID/main/$LAB_ID.sh
bash -x /tmp/$LAB_ID.sh

# common changes to jump VM
sudo rm /home/student/Downloads/*.*
im-config -n xim
ip route show
sudo sed --in-place 's/172.16.17.33/172.16.1.33/' /etc/netplan/01-config.yaml
sudo netplan apply

# disable debugging
set +x
