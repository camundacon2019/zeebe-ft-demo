1. Start brokers and gateway  
`docker-compose up -d zeebe-0 zeebe-1 zeebe-2 gateway`
* Start grafana  
`docker-compose up -d prometheus grafana`
* Open grafana `localhost:3000`
    * login with `admin:pass`
    * Open dashboard `Zeebe`
* Build client application in `load-generator/`  
`mvn install`
* Start some workload  
`docker-compose up -d starter worker`
* Check grafana dashboard to see that workflow instances are being created and completed. Wait for a minute, if you don't see anything immediately.
* Check zeebe status  
`docker-compose exec gateway zbctl status`  
Or, if you have `zbctl` locally  
`zbctl status`  
The result will look similar to the following.
```
Cluster size: 3
Partitions count: 2
Replication factor: 3
Brokers:
  Broker 0 - 172.31.0.2:26501
    Partition 1 : Leader
    Partition 2 : Follower
  Broker 1 - 172.31.0.3:26501
    Partition 1 : Follower
    Partition 2 : Follower
  Broker 2 - 172.31.0.4:26501
    Partition 1 : Follower
    Partition 2 : Leader
```
* Pick one broker which is the leader for any partition. For example, Broker 2 is the leader for partition 2. Let's kill the broker.  
`docker-compose stop zeebe-2`
* Check status again. After short delay, a new leader will be elected.
* Check grafana dashboard. You can observe that the new leader has started processing.
* Restart the stopped broker by  
`docker-compose start zeebe-2`
* Clean everything by `docker-compose down -v`
