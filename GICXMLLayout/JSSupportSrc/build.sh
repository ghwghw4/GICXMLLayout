#!/usr/bin/env bash
webpack
babel src/GlobalObject.js --out-file build/GlobalObject.js --presets=es2015
cat build/GlobalObject.js build/bundle.js > build/temp.js
cp -r build/temp.js build/bundle.js
rm build/temp.js
rm build/GlobalObject.js
cp -r build/bundle.js ../Assets/JSCore.js


