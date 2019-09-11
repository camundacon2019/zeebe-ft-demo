Demo code used in this [talk](https://www.camundacon.com/agenda/session/94358). Go [here](https://zeebe.io/) to know more about Zeebe.

##### Contents
* docker-compose.yml: docker configuration for
    * zeebe cluster with 3 brokers and 1 gateway
    * grafana and prometheus for monitoring
    * client application for generating work
* client-app:
    * starter : A java application that sends create workflow instance request at a fixed rate to the zeebe cluster.
    * worker: A java application that activates and completes jobs

##### Prerequisites

* docker and docker-compose
* Java (to build the client application)

##### Steps:
* Start brokers and gateway  
`docker-compose up -d zeebe-0 zeebe-1 zeebe-2 gateway`

* To execute the client application:
    * Build client application in `client-app/`  
        `mvn install`
    * Start the clients  
`docker-compose up -d starter worker`  
    * Alternatively, run the client applications locally  
      `java -jar client-app/targer/starter.jar`

* Start grafana  
`docker-compose up -d prometheus grafana`
* Open grafana `localhost:3000`
    * login with `admin:pass`
    * Open dashboard `Zeebe`
    * After you started the client applications, you can see if workflow instances are being created and completed in the dashboard. Wait for a minute, if you don't see anything immediately.  

* Check Zeebe cluster status  
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
* To stop a broker  
`docker-compose stop zeebe-2`
* Restart the stopped broker by  
`docker-compose start zeebe-2`

* Clean everything by `docker-compose down -v`
