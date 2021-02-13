#!/bin/bash
docker login
docker build -t vitalyven/docker-faiss:latest .
docker push vitalyven/docker-faiss:latest
docker logout