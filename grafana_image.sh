#!/bin/bash

############################
# Usage:
# File Name: grafana_image.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2017-09-14 18:19:50
############################

# 请在conf.sh中定义以下变量
GRAFANA="http://grafana.xxx.com"
KEY="eyJrRQZkVjM3J1bjRqNGliNGhWV1IiLCJuIjoicG5nIiwiaWQiOjF9"
CLUSTER=("newtv" "cn-cibn")
HOST=("10.1.1.1" "10.1.2.2")

source ./conf.sh

CWD=`cd $(dirname $0);pwd`
cd $CWD

varCluster=""
varHost=""
for id in ${CLUSTER[*]};do
	varCluster=$varCluster"&var-cluster=$id"
done

for id in ${HOST[*]};do
	varHost=$varHost"&var-host=$id"
done

NOW=`date +%s`
START=`echo $NOW|awk '{print $1-1800}'`
NOW="${NOW}000"
START="${START}000"
WIDTH="1500"
HEIGHT="1000"
COMMON="?refresh=30s&orgId=1&panelId=5&from=$START&to=$NOW$varCluster$varHost&var-app=All&width=$WIDTH&height=$HEIGHT&tz=UTC%2B08%3A00"

ERR_5xx="$GRAFANA/render/dashboard-solo/db/5xxgai-kuang$COMMON"
ERR_499="$GRAFANA/render/dashboard-solo/db/499bi-li$COMMON"

curl -s -H "Authorization: Bearer $KEY" $ERR_5xx -o 5xx.png
curl -s -H "Authorization: Bearer $KEY" $ERR_499 -o 499.png
./libs/weixin.py 5xx.png image
./libs/weixin.py 499.png image
