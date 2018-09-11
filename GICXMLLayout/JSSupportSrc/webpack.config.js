var webpack = require('webpack');
var _ = require('lodash');
var npmModules = require('./package.json').dependencies;
var vendorLibs = [];
if(npmModules) {
  _.each(npmModules,function (item,key) {
    vendorLibs.push(key);
  });
}

module.exports = {
  entry:{
    bundle : __dirname + '/src/Index.js',
    // vendor: vendorLibs,
  },
  output:{
    path: __dirname + '/build/',
    filename: '[name].js'
  },
  module:{
    rules:[
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        loaders: [
          'babel-loader?presets=es2015',
          'eslint-loader'
        ]
      }
    ]
  },
}
