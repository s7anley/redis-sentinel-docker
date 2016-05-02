#!/usr/bin/env bash

set -e

SENTINEL_CONFIGURATION_FILE=/etc/sentinel.conf

if [ "$AWS_IP_DISCOVERY" ]; then
   ANNOUNCE_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
fi

QUORUM=$QUORUM
: ${QUORUM:=2}

GROUP_NAME=$GROUP_NAME
: ${GROUP_NAME:=mymaster}

DEFAULT_PORT=$DEFAULT_PORT
: ${DEFAULT_PORT:=6379}

DOWN_AFTER=$DOWN_AFTER
: ${DOWN_AFTER:=30000}

FAILOVER_TIMEOUT=$FAILOVER_TIMEOUT
: ${FAILOVER_TIMEOUT:=180000}

PARALLEL_SYNCS=$PARALLEL_SYNCS
: ${PARALLEL_SYNCS:=1}

parse_addr () {
    local _retvar=$1
    IFS=':' read -ra ADDR <<< "$2"

    if [ "${ADDR[1]}" = "" ]; then
        ADDR[1]=$DEFAULT_PORT
    fi

    eval $_retvar='("${ADDR[@]}")'
}

print_slave () {
    local -a ADDR
    parse_addr ADDR $1
    echo "sentinel known-slave $GROUP_NAME ${ADDR[0]} ${ADDR[1]}" >> $SENTINEL_CONFIGURATION_FILE
}

print_master () {
    local -a ADDR
    parse_addr ADDR $1
    echo "sentinel monitor $GROUP_NAME ${ADDR[0]} ${ADDR[1]} $QUORUM" >> $SENTINEL_CONFIGURATION_FILE
}

echo "port 26379" >> $SENTINEL_CONFIGURATION_FILE

if [ "$ANNOUNCE_IP" ]; then
    echo "sentinel announce-ip $ANNOUNCE_IP" >> $SENTINEL_CONFIGURATION_FILE
fi

if [ "$ANNOUNCE_PORT" ]; then
    echo "sentinel announce-port $ANNOUNCE_PORT" >> $SENTINEL_CONFIGURATION_FILE
fi

print_master $MASTER
echo "sentinel down-after-milliseconds $GROUP_NAME $DOWN_AFTER" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel failover-timeout $GROUP_NAME $FAILOVER_TIMEOUT" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel parallel-syncs $GROUP_NAME $PARALLEL_SYNCS" >> $SENTINEL_CONFIGURATION_FILE

if [ "$SLAVES" ]; then
    for SLAVE in $(echo $SLAVES | tr ";" "\n")
    do
        if [ "$SLAVE" ]; then
            print_slave $SLAVE
        fi
    done
fi

redis-server $SENTINEL_CONFIGURATION_FILE --sentinel
