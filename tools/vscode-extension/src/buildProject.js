
const utils = require('./util');
const exec = require('child_process').exec;
const path = require('path');
const vscode = require('vscode');
const XMLNode = require('./XMLDoc');
const babel = require('@babel/core');
const fs = require('fs');

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

module.exports = function(cb){
    // 先将当前的文档保存
    if(vscode.window.activeTextEditor){
        vscode.window.activeTextEditor.document.save();
    }


    let projectPath = utils.getProjectPath();

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
};