# clone the registry repo if doesn't exist
cd /var/tmp
if [ ! -d "registry" ]; then
  git clone http://github.com/gbif/registry
fi
cd registry

# updates the repo
git pull
git checkout registry-2.105
cd registry-ws

# run the liquibase migration
mvn liquibase:update -Dliquibase.url=jdbc:postgresql://localhost:5432/registry -Dliquibase.driver=org.postgresql.Driver -Dliquibase.username=registry -Dliquibase.password=registry -Dliquibase.changeLogFile=../registry-liquibase/src/main/resources/liquibase/master.xml -DskipTests
cd ../../

# Default user admin, password is adminadmin
# GBIF Secretariat node (nodes are usually transferred from the GBIF Directory)
cat <<EOF | sudo -u postgres psql registry
INSERT INTO public.user VALUES(1, 'admin', 'admin@gbif.invalid', '\$S\$DJQSugJpMbIFPhJjEDRuVO12Dohno4.ZBOi5Qunv35.Am78hJz79', 'Admin', 'Admin', '{REGISTRY_ADMIN}', '"country"=>"ZZ"');
INSERT INTO node (key, continent, title, country, created_by, modified_by, type, participation_status) VALUES('02c40d2a-1cba-4633-90b7-e36e5e97aba8', 'EUROPE', 'GBIF Secretariat', 'DK', 'admin', 'admin', 'OTHER', 'ASSOCIATE');
EOF
