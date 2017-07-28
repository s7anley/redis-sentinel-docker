redis-sentinel
===

Dockerfiles for [Redis Sentinel](http://redis.io/topics/sentinel) based on alpine images, suitable for the production environment. Image is available directly from [public docker registry](https://registry.hub.docker.com/).
This images are updated via [pull requests to the `s7anley/redis-sentinel-docker` GitHub repo](https://github.com/s7anley/redis-sentinel-docker).


Redis Sentinel
---
Redis Sentinel provides high availability for Redis. In practical terms this means that using Sentinel you can create a Redis deployment that resists without human intervention to certain kind of failures.
Additionally also provides other collateral tasks such as monitoring, notifications and acts as a configuration provider for clients.

Supported tags and respective Dockerfile links
---
- `3.0.7`, `3.0` - [Dockerfile](https://github.com/s7anley/redis-sentinel-docker/Dockerfile-3.0)
- `3.2.9`, `3.2`, `latest` - [Dockerfile](https://github.com/s7anley/redis-sentinel-docker/Dockerfile)

Demo
---
For demonstration purposes you can use `docker-compose up -d` to bootstrap one redis master and slave and single sentinel to monitor them. In case you want to simulate sentinel cluster, scale number of sentinels with `docker-compose scale sentinel=3`.

To obtain confirm, that everything is working, we can ask for current master IP address with command:
```sh
$ docker exec redissentineldocker_sentinel_1 redis-cli -p 26380 sentinel get-master-addr-by-name mymaster
```

You can find all available sentinel commands in [documentation](http://redis.io/topics/sentinel#sentinel-commands)


How to use this image
---
 In documentation is suggested to add Sentinel one one at a time, in order to still guarantee that majority can be achieved only in one side of a partition, in the chance failures should happen in the process of adding new Sentinels. Recommended delay is 30 seconds.

```sh
$ docker run --name redis-sentinel_1 -d -e QUORUM=2 -e MASTER=<some ip address> redis-sentinel
```


Sentinel, Docker and possible issues
---
Running sentinel with network setting `bridge` will break Sentinel's auto-discovery, unless you instruct Docker to map the port 1:1. To force Sentinel to announce a specific IP (e.g. your host machine) and mapped port, you should use `ANNOUNCE_IP` and `ANNOUNCE_PORT` environment variables. For more information see [documentation](http://redis.io/topics/sentinel#sentinel-docker-nat-and-possible-issues).


AWS ECS
---
Amazon EC2 Container Service currently doesn't support `host` network setting, therefore Sentinel has to announce IP address of  host machine. Setting variable `AWS_IP_DISCOVERY` to true, will force auto discovery of internal IP address of EC2 machine. For further explanation see section above.


Environment Variables
---
`MASTER` - Colon-separated IP address and port or Redis master. Port is optional, `REDIS_PORT` is used when missing. E.g. `ip_address` or `ip_address:port`.

`REDIS_PORT` - Port on which is master available. Default value is `6379`.

`SENTINEL_PORT` - A port on which sentinel is communicating. A default value is `26379`. In case you change this value, don't forget to expose additional port manually. By default, only `26379` is exposed.

`MASTER_NAME` - Unique name for master. When defined, monitoring will be initialized.

`QUORUM` - Number of Sentinels that need to agree about the fact the master is not reachable, in order for really mark the slave as failing, and eventually start a fail over procedure if possible. Default value is `2`.

`DOWN_AFTER` - Time in milliseconds an instance should not be reachable for a Sentinel starting to think it is down. Default value `30000`.

`FAILOVER_TIMEOUT` - Wait time before failover retry of the same master. Default value `180000`.

`PARALLEL_SYNCS` - Sets the number of slaves that can be reconfigured to use the new master after a failover at the same time. Default value `1`.

`SLAVES` - Manually setting of all the slaves of monitored master. Accepted format is a colon-separated IP address and port for each slave server. Multiple slaves are separated by a semicolon. E.g. `ip_address:host;ip_address`.

`NOTIFICATION_SCRIPT` - Manually setting of notification-script on master. Script must exists and be executable or container will fail to start.

`CLIENT_RECONFIG_SCRIPT` - Manually setting of client-reconfig-script on master. Script must exists and be executable or container will fail to start.

`ANNOUNCE_IP` - Host machine IP address.

`ANNOUNCE_PORT` - Mapped sentinel port.

`AWS_IP_DISCOVERY` - Use internal IP address of AWS EC2 machine as `ANNOUNCE_IP`.

`AUTH_PASS` - Authentication password to use when connecting to master.
