const vscode = require('vscode');
const fs = require('fs');
const path = require('path');
const pathUtil = require('./utils/pathutils');
const Config = require('./utils/Config');
module.exports = function (context) {
    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.createPage', (file) => {
        createPage(file ? findDir(file.fsPath):getWorkDocumentPath());
    }));

    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.createJS', (file) => {
        createJSFile(file ? findDir(file.fsPath):getWorkDocumentPath());
    }));
};

function getWorkDocumentPath(){
    try {
        return findDir(vscode.window.activeTextEditor.document.fileName);
    } catch (error) {
        return pathUtil.getProjectPath(Config.getConfig());
    }
}

function findDir(filePath) {
    if (!filePath) return null;
    if (fs.statSync(filePath).isFile())
        return path.dirname(filePath);
    return filePath;
}

function createPage(relativePath) {
    if (!relativePath) return null;
    vscode.window.showInputBox({
        value: '',
        prompt: 'Please Enter Page Name',
        ignoreFocusOut: true,
        valueSelection: [-1, -1]
    }).then((pageName) => {
        if (!pageName || pageName.length === 0) return;

        // create xml file
        const xmlFileName = `${relativePath}/${pageName}.xml`;
        if (fs.existsSync(xmlFileName)) {
            vscode.window.showErrorMessage('该文件夹下已存在相同名称的文件');
            return;
        }
        const xmlContent = `<page title="${pageName}">
    <behaviors>
        <script path="./${pageName}.js" />
        <script private="true">
            $el.dataContext = new ${pageName}();
        </script>
    </behaviors>
    <scroll-view>
        <inset-panel inset="15">
            <stack-panel>
                <!-- 这里编辑页面内容 -->
            </stack-panel>
        </inset-panel>
    </scroll-view>
</page>`;

        fs.writeFileSync(xmlFileName, xmlContent, 'utf8');

        // create js file
        const jsFileName = `${relativePath}/${pageName}.js`;
        if (fs.existsSync(jsFileName)) {
            vscode.window.showErrorMessage('该文件夹下已存在相同名称的文件');
            return;
        }
        const jsContent = `class ${pageName}{
    constructor(){
                
    }
}`;
        fs.writeFileSync(jsFileName, jsContent, 'utf8');

        // 自动打开xml文件
        vscode.workspace.openTextDocument(xmlFileName)
            .then((editor) => {
                if (!editor) return;
                vscode.window.showTextDocument(editor);
            });
    });
}


function createJSFile(relativePath) {
    if (!relativePath) return null;
    vscode.window.showInputBox({
        value: '',
        prompt: 'Please Enter JavaScript File Name',
        ignoreFocusOut: true,
        valueSelection: [-1, -1]
    }).then((fileName) => {
        if (!fileName || fileName.length === 0) return;

        const jsFileName = `${relativePath}/${fileName}.js`;
        if (fs.existsSync(jsFileName)) {
            vscode.window.showErrorMessage('该文件夹下已存在相同名称的文件');
            return;
        }
        const jsContent = `class ${fileName}{
    constructor(){
                
    }
}
module.exports = ${fileName};
`;
        fs.writeFileSync(jsFileName, jsContent, 'utf8');
        // 自动打开js文件
        vscode.workspace.openTextDocument(jsFileName)
            .then((editor) => {
                if (!editor) return;
                vscode.window.showTextDocument(editor);
            });
    });
}