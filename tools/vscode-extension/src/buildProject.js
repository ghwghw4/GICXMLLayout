
const pathutils = require('./utils/pathutils');
const exec = require('child_process').exec;
const path = require('path');
const vscode = require('vscode');
const XMLNode = require('./XMLDoc');
const babel = require('@babel/core');
const fs = require('fs');
const Config = require('./utils/Config');

// 编译的时候被忽略的文件名称
const ignorFilesName = ['.vscode'];

function resolveFilePath(fileName,relativePath){
    if(relativePath[0]==='.'){
        const rootPath = pathutils.getBuildProjectPath(Config.getConfig()) +'/';
        const fullPath =path.resolve(path.dirname(fileName),relativePath);
        relativePath  = fullPath.replace(rootPath,'');
    }

    // if(relativePath[0]==='/'){
    //     relativePath = relativePath.substring(1,relativePath.length);
    // }

    if(path.extname(relativePath).length ===0){
        relativePath +='.js';
    }
    return relativePath;
}

const visitor = {
    //需要访问的节点名
    //访问器默认会被注入两个参数 path（类比成dom），state
    ExpressionStatement(jspath, state) {
        const node = jspath.node;
        //延当前节点向内部访问，判断是否符合console解析出的ast的特征
        const expressionNode = node['expression'];
        const isCallExpression = expressionNode.type === 'CallExpression';
        if (isCallExpression) {
            const calleeNode = expressionNode['callee'];//keyPathVisitor(expressionNode, ['callee', 'object', 'name']);
            const prototypeName = calleeNode.name;//keyPathVisitor(expressionNode, ['callee', 'property', 'name']);
            if (prototypeName === 'require') {
                const args = expressionNode.arguments;
                if (args.length === 1) {
                    const argumentNode = args[0];
                    if (argumentNode.type === 'StringLiteral') {
                        argumentNode.value = resolveFilePath(state.filename,argumentNode.value);
                    }
                }
            }
        }
    }
};

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
    require('@babel/plugin-transform-typeof-symbol'),
    {visitor}
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
            if(ignorFilesName.indexOf(path.basename(fileName)) >=0){
                fs.rmdirSync(fileName);
            }else{
                buildFromDirect(fileName);
            }
        } else if (stat.isFile) {
            if(ignorFilesName.indexOf(path.basename(fileName)) >=0){
                // 删除该文件
                fs.unlinkSync(fileName);
            }else{
                if (path.extname(fileName) === '.js') {
                    buildFromJSFile(fileName);
                } else if (path.extname(fileName) === '.xml') {
                    buildFromXMLFile(fileName);
                }
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

    const config = Config.getConfig();
    let projectPath = pathutils.getProjectPath(config);

    // 执行拷贝文件的指令
    /**
     * cd projectPath
     * 删除build文件夹
     * 将project 文件夹的所有内容拷贝到build文件夹中
     */
    exec(`cd ${projectPath} \n rm -rf ../build \n mkdir ../build \n cp -R ../${config.projectFolderName}/ ../build/${config.projectFolderName}`, () => {
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