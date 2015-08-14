#!/bin/bash
if [ -f /.mysql_db_created ];
then
    sleep 2
else
    # Wait until MySQL started and listens on port 3306.
    while [ -z "`netstat -tln | grep 3306`" ]; do
        echo '[createdb.sh] Waiting for MySQL to start...'
        sleep 1
    done
    echo '[createdb.sh] MySQL started.'
    DB_EXISTS=$(mysql -u root -h localhost -e "SHOW DATABASES LIKE 'OpenVBX';" | grep "OpenVBX" > /dev/null; echo "$?")
    if [[ DB_EXISTS -eq 1 ]];
    then
        echo "[createdb.sh] Creating database 'OpenVBX'..."
        RET=1
        while [[ RET -ne 0 ]]; do
            sleep 5
            mysql -u root -h localhost -e "CREATE DATABASE OpenVBX"
            RET=$?
        done
        echo "[createdb.sh] Done!"
    else
        echo "[createdb.sh] Skipped creation of database 'OpenVBX' – it already exists."
    fi
    touch /.mysql_db_created
fi
