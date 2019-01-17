#!/bin/bash
docker-machine ssh logging 'sudo sysctl -w vm.max_map_count=262144'
