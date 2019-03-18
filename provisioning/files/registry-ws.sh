#!/bin/bash -e

mkdir -p /usr/local/registry-ws
cd /usr/local/registry-ws

curl -o registry-ws.jar https://repository.gbif.org/repository/releases/org/gbif/registry/registry-ws/2.105/registry-ws-2.105.jar

cp /vagrant/provisioning/files/application.properties .
cp /vagrant/provisioning/files/appkeys.properties .
# Just log to the console, which will be picked up by SystemD.
mkdir -p conf
cp /vagrant/provisioning/files/logback.xml conf

# Start using SystemD.
sudo cp /vagrant/provisioning/files/registry-ws.service /etc/systemd/system/registry-ws.service
sudo systemctl enable registry-ws
sudo systemctl start registry-ws
