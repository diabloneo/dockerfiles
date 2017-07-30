#!/bin/bash

SS_CONFIG=${SS_CONFIG:-""}
SS_MODULE=${SS_MODULE:-"ss-server"}
OBFS_ENABLE=${OBFS_ENABLE:-"false"}
KCP_CONFIG=${KCP_CONFIG:-""}
KCP_FLAG=${KCP_FLAG:-"false"}

while getopts "s:m:k:x:o:" OPT; do
    case $OPT in
        s)
            SS_CONFIG=$OPTARG;;
        m)
            SS_MODULE=$OPTARG;;
        o)
            OBFS_ENABLE=$OPTARG;;
        k)
            KCP_CONFIG=$OPTARG;;
        x)
            KCP_FLAG="true";;
    esac
done

if [ "$KCP_FLAG" == "true" ] && [ "$KCP_CONFIG" != "" ]; then
    echo -e "\033[32mStarting kcptun......\033[0m"
    kcptun $KCP_CONFIG 2>&1 &
else
    echo -e "\033[33mKcptun not started......\033[0m"
fi

echo -e "\033[32mStarting shadowsocks......\033[0m"
if [ "$SS_CONFIG" != "" ]; then
    if [[ ${OBFS_ENABLE} = "true" ]]; then
        if [[ ${SS_MODULE} = "ss-local" ]]; then
            ${SS_MODULE} ${SS_CONFIG} --plugin "obfs-local" --plugin-opts "obfs=http;obfs-host=www.qq.com"
        else
            ${SS_MODULE} ${SS_CONFIG} --plugin "obfs-server" --plugin-opts "obfs=http"
        fi
    else
        $SS_MODULE $SS_CONFIG
    fi
else
    echo -e "\033[31mError: SS_CONFIG is blank!\033[0m"
    exit 1
fi
