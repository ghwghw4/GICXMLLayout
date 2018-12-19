const vscode = require('vscode');

const path = require('path');
// const GICJSNameShufix = '.compile.js';
const build = require('./buildProject');

// 文件压缩
var zipper = require("zip-local");
const utils = require('./utils/util');



// 压缩打包项目文件夹
function packWithZip(){
    const projectPath = utils.getProjectPath();
    const buildPath = path.resolve(projectPath, '../build');
    zipper.sync.zip(buildPath+'/project').compress().save(buildPath+'/project.zip');
}

module.exports = function (context) {
    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.buildjs', () => {
        build();
    }));

    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.buildAndZip', () => {
        build(function(){
            packWithZip();
        });
    }));
};