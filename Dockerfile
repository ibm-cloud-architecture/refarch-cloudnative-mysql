FROM mysql

ARG server_id=1

ENV SERVER_ID ${server_id}

COPY etc/mysql/mysql.conf.d/binlog.cnf /etc/mysql/mysql.conf.d/binlog.cnf

ADD scripts /root/scripts
WORKDIR /root/scripts

RUN chmod u+x /root/scripts/*.sh

ENTRYPOINT ["/root/scripts/docker-entrypoint-wrapper.sh"]
CMD ["mysqld"]
