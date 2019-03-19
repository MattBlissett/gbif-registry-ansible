# GBIF Registry with Ansible

This is a demonstration Vagrant+Ansible setup to run the [GBIF Registry webservice](https://github.com/gbif/registry) and [GBIF Registry console](https://github.com/gbif/registry-console).

It is not written for production use, although it would be a good start towards a production-quality Ansible script.  Parts of the scripts are taken from GBIF's production deployment modules — these are not shared publicly, as they are tightly tied in with GBIF's infrastructure.

The script:

* Starts an Ubuntu VM
* Installs PostgreSQL from the default Ubuntu packages, and creates a user and database
* Installs Rabbit MQ from the default Ubuntu packages, including the management interface
* Insalls Java, Apache HTTPD, and other necessary tools (Ubuntu packages)
* Runs Liquibase to create an empty Registry database
* Downloads a hardcoded version of the GBIF Registry webservice (2.105) and installs it as a SystemD service
* Extracts an included GBIF Registry console archive to be served by HTTPD.

The web service is exposed on port 8080, for example http://localhost:8080/dataset.

The console is exposed on port 8090, see http://localhost:8090.

Webservice logs can be seen with `journalctl -u registry-ws`.

## TODO

To meet the minimum for this to work, we must:

* Setup a configuration for the console to use a local API: https://github.com/gbif/registry-console/blob/master/src/api/util/config.js#L44
* Set up a REGISTRY_ADMIN user.
* Test that is is possible to create all entity types using that user, including new users.
* Install the Registry CLI.
* Test RabbitMQ message passing.
* Ensure SOLR indexing is working.
* Check absence of a directory isn't a problem.

Improvements are:

* Move the Bash scripts to Ansible declarations
* Changed the Registry Console to produce a tagged package, stored ideally in Nexus, which can be retrieved and deployed.
