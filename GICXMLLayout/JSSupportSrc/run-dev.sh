#!/usr/bin/env bash
echo '启动dev-server'
node_modules/.bin/webpack-dev-server --host 0.0.0.0
#open 'http://localhost:8080/webpack-dev-server/index.html'