#!/bin/sh

set -e

SENTINEL_CONFIGURATION_FILE=/etc/sentinel.conf

if [ "$AWS_IP_DISCOVERY" ]; then
   ANNOUNCE_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
fi

QUORUM=$QUORUM
: ${QUORUM:=2}

GROUP_NAME=$GROUP_NAME
: ${GROUP_NAME:=mymaster}

MASTER_PORT=$MASTER_PORT
: ${MASTER_PORT:=6379}

DOWN_AFTER=$DOWN_AFTER
: ${DOWN_AFTER:=30000}

FAILOVER_TIMEOUT=$FAILOVER_TIMEOUT
: ${FAILOVER_TIMEOUT:=180000}

PARALLEL_SYNCS=$PARALLEL_SYNCS
: ${PARALLEL_SYNCS:=1}

echo "port 26379" >> $SENTINEL_CONFIGURATION_FILE

if [ "$ANNOUNCE_IP" ]; then
    echo "sentinel announce-ip $ANNOUNCE_IP" >> $SENTINEL_CONFIGURATION_FILE
fi

if [ "$ANNOUNCE_PORT" ]; then
    echo "sentinel announce-port $ANNOUNCE_PORT" >> $SENTINEL_CONFIGURATION_FILE
fi

echo "sentinel monitor $GROUP_NAME $MASTER_IP $MASTER_PORT $QUORUM" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel down-after-milliseconds $GROUP_NAME $DOWN_AFTER" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel failover-timeout $GROUP_NAME $FAILOVER_TIMEOUT" >> $SENTINEL_CONFIGURATION_FILE
echo "sentinel parallel-syncs $GROUP_NAME $PARALLEL_SYNCS" >> $SENTINEL_CONFIGURATION_FILE

if [ "$SLAVES" ]; then
    for SLAVE in $(echo $SLAVES | tr ";" "\n")
    do
        if [ "$SLAVE" ]; then
            HOST=${SLAVE%:*}
            PORT=${SLAVE#*:}
            echo "sentinel known-slave $GROUP_NAME $HOST $PORT" >> $SENTINEL_CONFIGURATION_FILE
        fi
    done
fi

redis-server $SENTINEL_CONFIGURATION_FILE --sentinel
