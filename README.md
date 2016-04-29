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
###`MASTER_IP`
IP address of running Redis master.

###`MASTER_PORT`
Redis master port. Default value is `6379`.

###`GROUP_NAME`
Unique name for master group. Default value is `mymaster`.

###`QUORUM`
Number of Sentinels that need to agree about the fact the master is not reachable, in order for really mark the slave as failing, and eventually start a fail over procedure if possible.
Default value is `2`.
