# add copy-paste file on desktop
curl --silent https://raw.githubusercontent.com/learnf5/sslo11/main/sslo11_copy_paste.txt --output /home/student/Desktop/Copy-Paste.txt

# common changes to jump VM
sudo rm /home/student/Downloads/*.*
im-config -n xim
ip route show
sudo sed --in-place 's/172.16.17.33/172.16.1.33/' /etc/netplan/01-config.yaml
sudo chmod 600 /etc/netplan/01-config.yaml
sudo netplan apply

# disable debugging
set +x
