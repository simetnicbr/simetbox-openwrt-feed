#!/bin/sh

version=$(cat /etc/openwrt_version  | sed 's/[^0-9]//g')
echo "$version"
