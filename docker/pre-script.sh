#!/bin/bash
eval $(docker-machine env docker-host)
docker-machine scp cloudprober.cfg docker-host:/tmp
docker-machine ssh docker-host 'sudo sysctl -w net.ipv4.ping_group_range="0 5000"'
