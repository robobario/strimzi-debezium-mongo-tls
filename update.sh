#!/bin/bash
kubectl exec -it deploy/mongo-client -nmongo-tls -- bash -c "mongosh --tls --tlsCAFile /etc/certs/mongodb-CA.pem --tlsCertificateKeyFile /etc/certs/mongodb-client.pem -u root -p secret --eval \"use movies\" mongotest:27017"
kubectl exec -it deploy/mongo-client -nmongo-tls -- bash -c "mongosh --tls --tlsCAFile /etc/certs/mongodb-CA.pem --tlsCertificateKeyFile /etc/certs/mongodb-client.pem -u root -p secret --eval \"db.movies.insert({name:'Banana'})\" mongotest:27017"
kubectl exec -nmongo-tls my-cluster-kafka-0 -- bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic example.test.movies --from-beginning
