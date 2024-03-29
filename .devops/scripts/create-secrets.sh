#!/usr/bin/env bash

declare SECRET_DIR=../.secret
declare NAMESPACE=confluent

kubectl create secret tls ca-pair-sslcerts \
--cert=${SECRET_DIR}/secret/ca.pem \
--key=${SECRET_DIR}/ca-key.pem \
--namespace ${NAMESPACE}

kubectl create secret generic cloud-plain \
--from-file=plain.txt=${SECRET_DIR}/creds-client-kafka-sasl-user.txt \
--namespace ${NAMESPACE}

create secret generic kafka-client-config-secure \
--from-file=${SECRET_DIR}/kafka.properties \
--namespace ${NAMESPACE}

kubectl create secret generic cloud-sr-access \
--from-file=basic.txt=${SECRET_DIR}/creds-client-schema-registry.txt \
--namespace ${NAMESPACE}

kubectl create secret generic cloud-rest-access \
  --from-file=basic.txt=${SECRET_DIR}/creds-client-kafka-sasl-user.txt \
  --namespace ${NAMESPACE}

kubectl create secret docker-registry dockerconfigjson-github-com \
--from-file=${SECRET_DIR}/creds-docker-registry.txt \
--namespace=${NAMESPACE}



