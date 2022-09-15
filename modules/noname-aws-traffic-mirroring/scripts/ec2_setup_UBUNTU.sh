#! /bin/bash
#sudo apt-get update -y
#sudo apt-get install wget -y
sudo mkdir -p /opt/noname
sudo wget -O nonamesecurity.tar.gz ${package_url}
sudo tar -zxf nonamesecurity.tar.gz -C /opt/noname
cd /opt/noname
sudo ./noname_installer.sh --engine --management-hostname ${noname_management_host} --remote-engine-name ${remote_engine_name} --remote-engine-hostnames ${remote_engine_urls} --force
sleep 10s
sudo reboot
