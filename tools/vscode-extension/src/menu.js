const vscode = require('vscode');

const path = require('path');
// const GICJSNameShufix = '.compile.js';
const build = require('./buildProject');

// 文件压缩
var zipper = require("zip-local");
const utils = require('./util');

// const visitor = {
//     //需要访问的节点名
//     //访问器默认会被注入两个参数 path（类比成dom），state
//     ExpressionStatement(path, state) {
//         const node = path.node;
//         //延当前节点向内部访问，判断是否符合console解析出的ast的特征
//         const expressionNode = node['expression'];
//         const isCallExpression = expressionNode.type === 'CallExpression';
//         if (isCallExpression) {
//             const calleeNode = expressionNode['callee'];//keyPathVisitor(expressionNode, ['callee', 'object', 'name']);
//             const prototypeName = calleeNode.name;//keyPathVisitor(expressionNode, ['callee', 'property', 'name']);
//             if (prototypeName === 'require') {
//                 const args = expressionNode.arguments;
//                 if (args.length === 1) {
//                     const argumentNode = args[0];
//                     if (argumentNode.type === 'StringLiteral') {
//                         const value = argumentNode.value;
//                         if (value.indexOf(GICJSNameShufix) === -1 && value.substring(value.length - 3, value.length) === '.js') {
//                             argumentNode.value = value.substring(0, value.length - 3) + GICJSNameShufix;
//                         }
//                     }
//                 }
//             }
//         }
//     }
// };



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