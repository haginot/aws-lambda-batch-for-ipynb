#!/bin/bash
docker build -t aws-lambda-batch-for-ipynb . 
DOCKER_PID=$(docker run --rm -e SERVICE_ACCOUNT= -d -p 9001:8080  aws-lambda-batch-for-ipynb:latest)
curl -XPOST "http://localhost:9001/2015-03-31/functions/function/invocations" -d '{}'
echo 'docker logs'
docker logs $DOCKER_PID
docker kill $DOCKER_PID
