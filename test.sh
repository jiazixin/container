#!/bin/bash

set -euo pipefail

###### 基础变量 ######
SOURCE_ADDRESS="docker.io"
TARGET_ADDRESS="crpi-rabkw7fs4hdymafj.cn-huhehaote.personal.cr.aliyuncs.com"
TARGET_USERNAME="子夜黑猫q"
TARGET_PASSWORD="118107Jzx."

# 检测并安装所需软件
if command -v apt &> /dev/null; then
    sudo apt-get install -y skopeo
elif command -v dnf &> /dev/null; then
    sudo dnf install -y skopeo
elif command -v apk &> /dev/null; then
    sudo apk add skopeo
fi

###### 镜像列表 ######
IMAGES=(
library/almalinux:{9,10}
library/debian:{12,13}
library/alpine:3.23
library/centos:7
gitea/gitea:1.26.4
gitea/act_runner:0.6.1
kodcloud/{kodbox,kodoffice}:latest
library/golang:1.26.4
library/{docker,mariadb,ubuntu,tomcat}:latest
library/nginx:{1.30.3,1.31.2,alpine,latest}
library/mysql:{5.7.44,8.0.42,8.4.3,latest}
library/redis:{4.0.8,6.2.5,latest}
library/node:22-alpine
p3terx/{aria2-pro,ariang}:latest
grafana/grafana:{11.6.16,latest}
louislam/uptime-kuma:2.4.0
gitlab/gitlab-ce:18.11.6-ce.0
gitlab/gitlab-runner:v18.11.3
gitlab/gitlab-runner-helper:{x86_64-v18.11.3,x86_64-v17.11.0}
zabbix/{zabbix-server-mysql,zabbix-web-nginx-mysql,zabbix-java-gateway,zabbix-agent2}:7.0.27-alpine
calico/{cni,node,kube-controllers}:v3.32.0
)

###### 拉取镜像 ######
for IMAGE in "${IMAGES[@]}"; do
    RAW_IMAGE=$(echo $IMAGE | awk -F '/' '{print $NF}')

    echo -e "正在同步 [$IMAGE]...\n"
    skopeo copy \
        docker://"${SOURCE_ADDRESS}/${IMAGE}" \
        docker://"${TARGET_ADDRESS}/base-j/${RAW_IMAGE}" \
        --dest-username "$TARGET_USERNAME" \
        --dest-password "$TARGET_PASSWORD"
done
