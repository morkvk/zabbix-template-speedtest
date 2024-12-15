#!/bin/bash
# zbx-speedtest-wrapper.sh

docker exec morkovka-zabbix-speedtest /copy/zbx-speedtest.sh "$@"
