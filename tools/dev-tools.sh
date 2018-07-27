#!/usr/bin/env bash
# 安装http-server
sudo npm i -g http-server
#启动微型服务器。 服务器根目录设置为当前目录的前一级
http-server -p 8080 ../Example/GICXMLLayout/templates

