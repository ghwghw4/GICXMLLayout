// const vscode = require('vscode');
/**
 * 插件被激活时触发，所有代码总入口
 * @param {*} context 插件上下文
 */
exports.activate = function (context) {
    console.log('恭喜，您的扩展“vscode-plugin-demo”已被激活！');
    require('./init')(context); // 初始化插件
    require('./completion/completion')(context); // 自动补全
    require('./menu')(context); // 菜单when命令
    require('./createPageExtenion')(context); // 创建页面扩展
};

/**
 * 插件被释放时触发
 */
exports.deactivate = function () {
    console.log('您的扩展“vscode-plugin-demo”已被释放！')
};