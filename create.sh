#!/bin/bash
minikube start
IP=$(minikube ip)
minikube delete && minikube start --insecure-registry="${IP}/24"
minikube addons enable registry
kubectl create namespace mongo-tls
kubectl apply -f ./mongo-cluster -n mongo-tls
kubectl create -f 'https://strimzi.io/install/latest?namespace=mongo-tls' -n mongo-tls
kubectl apply -f ./strimzi-cluster -n mongo-tls
kubectl wait deployment -n mongo-tls mongo --for condition=Available=True --timeout=300s
sleep 10
# initiate the mongo replicaset https://www.mongodb.com/docs/manual/tutorial/convert-standalone-to-replica-set
kubectl exec -it deploy/mongo-client -nmongo-tls -- bash -c "mongosh --tls --tlsCAFile /etc/certs/mongodb-CA.pem --tlsCertificateKeyFile /etc/certs/mongodb-client.pem -u root -p secret --eval \"rs.initiate()\" mongotest:27017"
kubectl exec -it deploy/mongo-client -nmongo-tls -- bash -c "mongosh --tls --tlsCAFile /etc/certs/mongodb-CA.pem --tlsCertificateKeyFile /etc/certs/mongodb-client.pem -u root -p secret --eval \"use movies\" mongotest:27017"
kubectl exec -it deploy/mongo-client -nmongo-tls -- bash -c "mongosh --tls --tlsCAFile /etc/certs/mongodb-CA.pem --tlsCertificateKeyFile /etc/certs/mongodb-client.pem -u root -p secret --eval \"db.movies.insert({name:'Banana'})\" mongotest:27017"
kubectl wait kafka -n mongo-tls my-cluster --for condition=Ready=True --timeout=300s
kubectl wait kafkaconnect -n mongo-tls my-connect-cluster --for condition=Ready=True --timeout=300s
sleep 10
kubectl exec -nmongo-tls my-cluster-kafka-0 -- bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic example.test.movies --from-beginning
