const vscode = require('vscode');
const babel = require('@babel/core');
const fs = require('fs');
const path = require('path');
// const GICJSNameShufix = '.compile.js';
const exec = require('child_process').exec;
const XMLNode = require('./XMLDoc');
// 文件压缩
var zipper = require("zip-local");

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

// 调用的插件
const plugins = [
    require('@babel/plugin-transform-classes'),
    require('@babel/plugin-transform-arrow-functions'),
    require('@babel/plugin-transform-block-scoping'),
    require('@babel/plugin-transform-instanceof'),
    require('@babel/plugin-transform-template-literals'),
    require('@babel/plugin-transform-for-of'),
    require('@babel/plugin-transform-computed-properties'),
    require('@babel/plugin-transform-destructuring'),
    require('@babel/plugin-transform-parameters'),
    require('@babel/plugin-transform-shorthand-properties'),
    require('@babel/plugin-transform-sticky-regex'),
    require('@babel/plugin-transform-typeof-symbol')
];

// 压缩并且移除注释
const babelConfig = { plugins: plugins, generatorOpts: { minified: true, comments: false } };

function getProjectPath(){
    let projectPath = path.dirname(vscode.window.activeTextEditor.document.uri.path);
    // 获取项目的根目录
    while (projectPath !== '/' && (path.basename(projectPath) !== 'project')) {
        projectPath = path.resolve(projectPath, '..');
    }

    if (projectPath === '/') {
        vscode.window.showErrorMessage('请确保您的项目文件保存在 project 目录,并且打开的文件是属于project目录下的文件');
        return;
    }
    return projectPath;
}

function build(cb) {
    let projectPath = getProjectPath();

    // 执行拷贝文件的指令
    /**
     * cd projectPath
     * 删除build文件夹
     * 将project 文件夹的所有内容拷贝到build文件夹中
     */
    exec(`cd ${projectPath} \n rm -rf ../build \n mkdir ../build \n cp -R ../project/ ../build/project`, () => {
        const buildPath = path.resolve(projectPath, '../build');
        try {
            // 遍历获取所有的JS的文件，并且进行es6翻译
            buildFromDirect(buildPath);
        } catch (error) {
            console.error(error);
            vscode.window.showErrorMessage('编译失败:' + error);
        }
        vscode.window.showInformationMessage(`编译完成`);
        if(cb){
            cb();
        }
    });
}

/**
 * 
 * @param {*} dirName 
 */
function buildFromDirect(dirName) {
    const files = fs.readdirSync(dirName);
    files.forEach(function (item, index) {
        const fileName = `${dirName}/${item}`;
        const stat = fs.lstatSync(fileName)
        if (stat.isDirectory() === true) {
            buildFromDirect(fileName);
        } else if (stat.isFile) {
            if (path.extname(fileName) === '.js') {
                buildFromJSFile(fileName);
            } else if (path.extname(fileName) === '.xml') {
                buildFromXMLFile(fileName);
            }
        }
    })
}

// 直接编译JS文件
function buildFromJSFile(fileName) {
    const result = babel.transformFileSync(fileName, babelConfig);
    if (result) {
        fs.writeFileSync(fileName, result.code, 'utf8');
    } else {
        vscode.window.showErrorMessage('编译失败，失败文件 ：' + fileName);
    }
}

// 编译XML文件中的JS内容
function buildFromXMLFile(fileName) {
    const doc = fs.readFileSync(fileName, 'utf8');
    try {
        let xmldoc = XMLNode.parse(doc);
        if (xmldoc) {
            buildFromXMLNode(xmldoc);
            fs.writeFileSync(fileName, XMLNode.write(xmldoc), 'utf8');
        } else {
            vscode.window.showErrorMessage('XML文件打开失败，失败文件 ：' + fileName);
        }
    } catch (error) {
        vscode.window.showErrorMessage('XML文件打开失败，失败文件 ：' + fileName);
    }

}

/**
 * 
 * @param {XMLNode} xmlNode 
 */
function buildFromXMLNode(xmlNode) {
    if (xmlNode.name === 'script' && xmlNode.content && xmlNode.content.length > 0) {
        const result = babel.transformSync(xmlNode.content, babelConfig);
        xmlNode.content = result.code;
    } else {
        xmlNode.subNodes.forEach(sub => {
            buildFromXMLNode(sub);
        });
    }
}

// 压缩打包项目文件夹
function packWithZip(){
    const projectPath = getProjectPath();
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