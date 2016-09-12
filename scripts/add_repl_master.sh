#!/bin/bash

MASTER_HOST=""
MASTER_IP=""
MASTER_PORT=""
MASTER_USER=""
MASTER_PASSWORD=""

_default_master_port=3306
_default_repl_user=repl

function print_usage() {

    echo "$0 --master-host=<master hostname> --master-ip=<master_ip> [--master-port=<port>] [--repl-user=<replication user> --repl-passwd=<replication password>"
}

for param in $@; do
    case ${param} in
        --master-host=*)
            MASTER_HOST=`echo ${param} | cut -d= -f2`
            ;;
        --master-ip=*)
            MASTER_IP=`echo ${param} | cut -d= -f2`
            ;;
        --master-port=*)
            MASTER_PORT=`echo ${param} | cut -d= -f2`
            ;;
        --repl-user=*)
            MASTER_USER=`echo ${param} | cut -d= -f2`
            ;;
        --repl-passwd=*)
            MASTER_PASSWORD=`echo ${param} | cut -d= -f2`
            ;;
        *)
            echo "Unrecognized parameter: ${param}"
            print_usage
            exit 1
            ;;
    esac
done

if [ -z "${MASTER_HOST}" ]; then
    echo "Missing parameter(s): --master-host"
    print_usage
    exit 1
fi

if [ -z "${MASTER_IP}" ]; then
    echo "Missing parameter(s): --master-ip"
    print_usage
    exit 1
fi

if [ -z "${MASTER_PASSWORD}" ]; then
    echo "Missing parameter(s): --repl-passwd"
    print_usage
    exit 1
fi

if [ -z "${MASTER_PORT}" ]; then
    echo "Using default port: ${_default_master_port}"
    MASTER_PORT=${_default_master_port}
fi

if [ -z "${MASTER_USER}" ]; then
    echo "Using default user: ${_default_repl_user}"
    MASTER_USER=${_default_repl_user}
fi


# add master to /etc/hosts
echo "${MASTER_IP} ${MASTER_HOST}" >> /etc/hosts

echo "Setting master host to ${MASTER_HOST} ..."
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CHANGE MASTER TO MASTER_HOST='${MASTER_IP}', MASTER_PORT=${MASTER_PORT}, MASTER_USER='${MASTER_USER}', MASTER_PASSWORD='${MASTER_PASSWORD}', MASTER_AUTO_POSITION=1;"

mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "START SLAVE;"
