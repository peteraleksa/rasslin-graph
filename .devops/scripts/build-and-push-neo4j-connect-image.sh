#!/usr/bin/env bash

declare N4J_VERSION=5.0.4
declare GCF_VERSION=1.2.0
declare TAG=ghcr.io/peteraleksa/kafka-connect-neo4j-gcf:${N4J_VERSION}_${GCF_VERSION}_linux-amd64

docker build . -f ../docker/Dockerfile.KafkaConnect_Neo4j_GCF -t ${TAG}
docker push ${TAG}
