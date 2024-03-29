#!/bin/bash

echo "Starting deployment"

## Build image for log producing app
docker build -t log-producing-app-go:latest -f ../src/Dockerfile ../src

## Deploys volumes for logs
helm upgrade -i  logs-volumes logs-volumes/ --values logs-volumes/values.yaml

## Deploys elasticsearch
helm upgrade -i  elasticsearch-dev elasticsearch/ --values elasticsearch/values.yaml

## Deploys Logstash
helm upgrade -i  logstash-dev logstash/ --values logstash/values.yaml

## Deploys filebeat
helm upgrade -i  filebeat-dev filebeat/ --values filebeat/values.yaml

## Deploys Kibana
helm upgrade -i  kibana-dev kibana/ --values kibana/values.yaml

## Deploy app
helm upgrade -i log-producing-app log-producing-app/ --values log-producing-app/values.yaml

echo ""

# Gets Localhost port for kibana instance
KIBANA_PORT=`kubectl get svc --all-namespaces -o go-template='{{range .items}}{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}{{end}}'`

echo "Kibana app is running on localhost:$KIBANA_PORT"