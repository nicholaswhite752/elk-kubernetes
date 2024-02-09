#!/bin/bash

echo "Starting deployment"

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