#!/bin/bash

# some configuration
SLAVE_HOST=""
SLAVE_IP=""
SLAVE_USER=""
SLAVE_PASSWORD=""

_default_repl_user=repl

function print_usage() {

    echo "$0 --slave-host=<master hostname> --slave-ip=<master_ip> [--repl-user=<replication user> [--repl-passwd=<replication password>]"
}

for param in $@; do
    case ${param} in
        --slave-host=*)
            SLAVE_HOST=`echo ${param} | cut -d= -f2`
            ;;
        --slave-ip=*)
            SLAVE_IP=`echo ${param} | cut -d= -f2`
            ;;
        --repl-user=*)
            SLAVE_USER=`echo ${param} | cut -d= -f2`
            ;;
        --repl-passwd=*)
            SLAVE_PASSWORD=`echo ${param} | cut -d= -f2`
            ;;
        *)
            echo "Unrecognized parameter: ${param}"
            print_usage
            exit 1
            ;;
    esac
done

if [ -z "${SLAVE_HOST}" ]; then
    echo "Missing parameter(s): --slave-host"
    print_usage
    exit 1
fi

if [ -z "${SLAVE_IP}" ]; then
    echo "Missing parameter(s): --slave-ip"
    print_usage
    exit 1
fi

if [ -z "${SLAVE_USER}" ]; then
    echo "Using default replication user: ${_default_repl_user}"
    SLAVE_USER=${_default_repl_user}
fi

if [ -z "${SLAVE_PASSWORD}" ]; then
    _default_repl_passwd=`cat /dev/urandom | tr -dc '$@#!%^&A-Za-z0-9' | head c16`
    echo "Using generated replication password: ${_default_repl_passwd}"
    SLAVE_PASSWORD=${_default_repl_passwd}
fi


# add to /etc/hosts
echo "${SLAVE_IP} ${SLAVE_HOST}" >> /etc/hosts

# grant replication privileges to the host
echo "Creating user '${SLAVE_USER}'@'${SLAVE_IP}' with password \"${SLAVE_PASSWORD}\" ..."
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER '${SLAVE_USER}'@'${SLAVE_IP}' IDENTIFIED BY '${SLAVE_PASSWORD}';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT REPLICATION SLAVE ON *.* TO '${SLAVE_USER}'@'${SLAVE_IP}';"

