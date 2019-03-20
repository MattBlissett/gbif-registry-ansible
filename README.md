# GBIF Registry with Ansible

This is a demonstration Vagrant+Ansible setup to run the [GBIF Registry webservice](https://github.com/gbif/registry) and [GBIF Registry console](https://github.com/gbif/registry-console).

It is not written for production use, although it includes all the necessary steps for a production deployment.  Parts of the scripts are taken from GBIF's production deployment modules — these are not shared publicly, as they are tightly tied in with GBIF's infrastructure.  (Other parts are not good examples of Ansible code.)

The script:

* Starts an Ubuntu VM
* Installs PostgreSQL from the default Ubuntu packages, and creates a user and database
* Installs RabbitMQ from the default Ubuntu packages, including the management interface
* Installs Java, Apache HTTPD, and other necessary tools (Ubuntu packages)
* Runs Liquibase to create an empty Registry database, and adds a default user and node
* Downloads version 2.105 of the GBIF Registry webservice and installs it as a SystemD service
* Downloads version 2.105 of the GBIF Registry CLI module and installs it as a SystemD service, but doesn't start it
* Extracts an included GBIF Registry console archive to be served by HTTPD.

The web service is exposed on port 8080, for example http://localhost:8080/dataset.

The console is exposed on port 8090, see http://localhost:8090.

Webservice logs can be seen with `journalctl -u registry-ws`.

RabbitMQ's interface is visible at http://localhost:15672/, with user `guest` and password `guest`.

The Registry admin user is `admin` with password `adminadmin`.

## TODO

Improvements are:

* Move the Bash scripts to Ansible declarations
* Changed the Registry Console to produce a tagged package, stored ideally in Nexus, which can be retrieved and deployed.
