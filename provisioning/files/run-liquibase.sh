# clone the registry repo if doesn't exist
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
