module.exports = {
  parser: 'babel-eslint',//使用babel-eslint来作为eslint的解析器
  extends: "airbnb-base",
  globals: {    // 声明在代码中自定义的全局变量
    'window': true,
    'document': true,
    'WebSocket': true,
    'localStorage': true,
  },
  parserOptions: {      // 设置解析器选项
    sourceType: 'module'    // 表明自己的代码是ECMAScript模块
  },
  // 启用额外的规则或者覆盖基础配置中的规则的默认选项
  rules: {
    // allow paren-less arrow functions
    "eol-last":0,
    'no-plusplus': 0,
    'no-underscore-dangle': 0,
    'no-extend-native': 0,
    'func-names': 0,
    'consistent-return': 0,
    'no-param-reassign': 0,
    'max-len': 0,
    'no-prototype-builtins': 0
  },
};
