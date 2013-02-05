mongo-serve
===========
 
Simple web server for JSON stored in mongod.

## Prepare DB

For example,

    % mongod &
    % find output/json -name law.json -exec mongoimport -d db -c law --upsert --upsertFields name {} \;

## Run HTTP frontend
    % npm run prepublish && node app.js


### Note to self

Push local db to production
* mongodump -d db
* mongorestore --drop -h ds049237.mongolab.com:49237 -d twlaw -u admin -p $PASSWD dump/db

Company
* sed -E 's/^([0-9]+),{/{"id":\1,/' *0.json > company.json
* mongoimport --drop -h ds049347.mongolab.com:49347 -d company -c profile --upsert --upsertFields id -u admin -p r0nny company.json

Law progress
* mongoimport --drop -h ds043467.mongolab.com:43467 -d law-progress -c law-progress --upsert --upsertfields id -u admin -p $PASSWD progress.json
