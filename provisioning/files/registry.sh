#!/bin/bash -e

# Registry Web Service
mkdir -p /usr/local/registry-ws
cd /usr/local/registry-ws

curl -o registry-ws.jar https://repository.gbif.org/repository/releases/org/gbif/registry/registry-ws/2.105/registry-ws-2.105.jar

cp /vagrant/provisioning/files/registry-ws/application.properties .
cp /vagrant/provisioning/files/registry-ws/appkeys.properties .
# Just log to the console, which will be picked up by SystemD.
mkdir -p conf
cp /vagrant/provisioning/files/registry-ws/logback.xml conf

# Start using SystemD.
sudo cp /vagrant/provisioning/files/registry-ws.service /etc/systemd/system/registry-ws.service
sudo systemctl enable registry-ws
sudo systemctl start registry-ws

# Registry CLI
mkdir -p /usr/local/registry-cli
cd /usr/local/registry-cli

curl -o registry-cli.jar https://repository.gbif.org/repository/releases/org/gbif/registry/registry-cli/2.105/registry-cli-2.105-shaded.jar

cp /vagrant/provisioning/files/registry-cli/registry-doi-updater.yaml .
# Just log to the console, which will be picked up by SystemD.
cp /vagrant/provisioning/files/registry-cli/logback-doi-updater.xml .

# Add to SystemD, but don't start it as the credentials won't work.
sudo cp /vagrant/provisioning/files/registry-doi-updater.service /etc/systemd/system/registry-doi-updater.service
sudo systemctl daemon-reload
sudo systemctl disable registry-doi-updater
sudo systemctl stop registry-doi-updater

# Create RabbitMQ queues. This is normally done by the processes that read from the queues when they start up, but for the
# registry-doi queue — it's not being started, and for the crawler_coordinator queue, we aren't running the crawler here.
curl -u guest:guest 'http://localhost:15672/api/exchanges/%2F/registry' -X PUT -H 'Content-type: application/json' --data '{"vhost":"/","name":"registry","type":"topic","durable":"true","auto_delete":"false","internal":"false","arguments":{}}'

curl -u guest:guest 'http://localhost:15672/api/queues/%2F/registry-doi' -X PUT -H 'Content-type: application/json' --data '{"vhost":"/","name":"registry-doi","durable":"true","auto_delete":"false","arguments":{}}'
curl -u guest:guest 'http://localhost:15672/api/bindings/%2F/e/registry/q/registry-doi' -H 'Content-type: application/json' --data '{"vhost":"/","source":"registry","destination_type":"q","destination":"registry-doi","routing_key":"doi.change","arguments":{}}'

curl -u guest:guest 'http://localhost:15672/api/queues/%2F/registry-change' -X PUT -H 'Content-type: application/json' --data '{"vhost":"/","name":"registry-change","durable":"true","auto_delete":"false","arguments":{}}'
curl -u guest:guest 'http://localhost:15672/api/bindings/%2F/e/registry/q/registry-change' -H 'Content-type: application/json' --data '{"vhost":"/","source":"registry","destination_type":"q","destination":"registry-change","routing_key":"registry.change.#","arguments":{}}'

curl -u guest:guest 'http://localhost:15672/api/queues/%2F/crawler_coordinator' -X PUT -H 'Content-type: application/json' --data '{"vhost":"/","name":"crawler_coordinator","durable":"true","auto_delete":"false","arguments":{}}'
curl -u guest:guest 'http://localhost:15672/api/bindings/%2F/e/registry/q/crawler_coordinator' -H 'Content-type: application/json' --data '{"vhost":"/","source":"registry","destination_type":"q","destination":"crawler_coordinator","routing_key":"crawl.start","arguments":{}}'
