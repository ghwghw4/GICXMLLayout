#!/usr/bin/env bash
webpack
babel src/GlobalObject.js --out-file build/GlobalObject.js --presets=es2015
# 合并js代码
cat build/GlobalObject.js  build/bundle.js > build/temp.js
cp -r build/temp.js build/bundle.js
rm build/temp.js
rm build/GlobalObject.js
# 压缩js代码
uglifyjs build/bundle.js -m -o build/bundle-min.js
cp -r build/bundle-min.js ../Assets/JSCore.js

