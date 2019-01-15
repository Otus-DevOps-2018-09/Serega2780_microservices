#!/bin/bash
eval $(docker-machine env docker-host)
docker-machine scp cloudprober.cfg docker-host:/tmp
docker-machine scp daemon.json docker-host:/tmp
docker-machine scp telegraf.conf docker-host:/tmp
docker-machine ssh docker-host 'sudo sysctl -w net.ipv4.ping_group_range="0 5000"'
docker-machine ssh docker-host sudo cp -r /tmp/daemon.json /etc/docker # to make Docker daemon
docker-machine ssh docker-host 'sudo systemctl restart docker' # send monitoring metrics to Prometheus
