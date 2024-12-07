#!/bin/bash
# zbx-speedtest-wrapper.sh

docker exec morkovka-zabbix-speedtest /zbx-speedtest.sh "$@"
