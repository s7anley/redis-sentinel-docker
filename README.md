[![Docker Pulls](https://img.shields.io/docker/pulls/s7anley/redis-sentinel-docker.svg)](https://hub.docker.com/r/s7anley/redis-sentinel-docker/)
[![Docker Stars](https://img.shields.io/docker/stars/s7anley/redis-sentinel-docker.svg)](https://hub.docker.com/r/s7anley/redis-sentinel-docker/)
[![](https://badge.imagelayers.io/s7anley/redis-sentinel-docker:latest.svg)](https://imagelayers.io/?images=s7anley/redis-sentinel-docker:latest)

redis-sentinel-docker
===

Dockerfile for [Redis Sentinel](http://redis.io/topics/sentinel). Image is available directly from [public docker registry](https://registry.hub.docker.com/).
This image is updated via [pull requests to the `s7anley/redis-sentinel-docker` GitHub repo](https://github.com/s7anley/redis-sentinel-docker).

Redis Sentinel
---
Redis Sentinel provides high availability for Redis. In practical terms this means that using Sentinel you can create a Redis deployment that resists without human intervention to certain kind of failures.
Additionally also provides other collateral tasks such as monitoring, notifications and acts as a configuration provider for clients.

How to use this image
---
Simple development example. Let say redis server is running at internal address 172.17.0.2.

`docker run --name redis-sentinel_1 -d -e QUORUM=1 -e MASTER_IP=172.17.0.2 redis-sentinel`

Sentinel with start monitoring Redis instance running on provided IP address and Sentinel auto discovery will take care of finding slaves on other sentinels which are monitoring same master.

Environment Variables
---
`MASTER_IP`
IP address of running Redis master.

`MASTER_PORT`
Redis master port. Default value is `6379`.

`GROUP_NAME`
Unique name for master group. Default value is `mymaster`.

`QUORUM`
Number of Sentinels that need to agree about the fact the master is not reachable, in order for really mark the slave as failing, and eventually start a fail over procedure if possible.
Default value is `2`.

`ANNOUNCE_IP`
In case of mapping, configure IP address of sentinel server. Read more in [documentation](Sentinel, Docker, NAT, and possible issues).

`ANNOUNCE_PORT`
In case of mapping, configure mapped port of sentinel server. Read more in [documentation](Sentinel, Docker, NAT, and possible issues).

`DOWN_AFTER`
Time in milliseconds an instance should not be reachable for a Sentinel starting to think it is down. Default value `1500`.

`FAILOVER_TIMEOUT`
Wait time before failover retry of the same master. Default value `30000`.

`PARALLEL_SYNCS`
Sets the number of slaves that can be reconfigured to use the new master after a failover at the same time. Default value `1`.

`SLAVES`
Manually configure all the slaves of monitored master. Expected format: `ip_address:host;ip_address:host`.

`AWS_IP_DISCOVERY`
Use internal IP address of AWS EC2 machine as `ANNOUNCE_IP`.
