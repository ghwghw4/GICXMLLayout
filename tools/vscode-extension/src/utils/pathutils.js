const path = require('path');
const vscode = require('vscode');
const Config = require('./Config');

const pathutil = {
    /**
     * 
     * @param {Config} config 
     */
    getProjectPath(config) {
        let projectPath = path.dirname(vscode.window.activeTextEditor.document.uri.path);
        // 获取项目的根目录
        while (projectPath !== '/' && (path.basename(projectPath) !== config.projectFolderName)) {
            projectPath = path.resolve(projectPath, '..');
        }

        if (projectPath === '/') {
            vscode.window.showErrorMessage(`请确保您的项目文件保存在 ${config.projectFolderName} 目录,并且打开的文件是属于${config.projectFolderName}目录下的文件`);
            return;
        }
        return projectPath;
    },

    /**
     * 获取build目录的地址
     * @param {Config} config 
     */
    getBuildPath(config){
        const buildPath = path.resolve(this.getProjectPath(config), '../build');
        return buildPath;
    },
    /**
     * 获取build目录中的project目录的地址
     * @param {Config} config 
     */
    getBuildProjectPath(config){
        const buildPath = this.getBuildPath(config);
        return `${buildPath}/${config.projectFolderName}`
    },
    /**
     * 获取当前工程名
     */
    getProjectName: function (projectPath) {
        return path.basename(projectPath);
    },
    getAbsolutePath(fileName, text, rootPath) {
        const normalizedText = path.normalize(text);
        const isPathAbsolute = normalizedText.startsWith(path.sep);
    
        let rootFolder = path.dirname(fileName);
        let pathEntered = normalizedText;
    
        if (isPathAbsolute) {
            rootFolder = rootPath || '';
        }
        return path.join(rootFolder, pathEntered);
    }
};

module.exports = pathutil;