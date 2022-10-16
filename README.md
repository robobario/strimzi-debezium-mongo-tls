# mongodb-with-tls strimzi debezium

This demonstrates running:
1. a strimzi kafka cluster with plain auth
2. a mongodb ReplicaSet with mutual tls enabled
3. a kafka connect cluster deployed by strimzi with a debezium mongo source connector

It runs on minikube and installs a minikube registry addon so that strimzi has somewhere to push the build kafka connect image.

## How to run

run [create.sh](create.sh). This will configure minikube and install everything, wait for the systems to come up and then start a kafka console consumer. All going well you should see a message produced by the debezium connector.

