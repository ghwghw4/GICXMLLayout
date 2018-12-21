const path = require('path');
const vscode = require('vscode');
const Config = require('./Config');
const fs = require('fs');

const pathutil = {
    /**
     * 
     * @param {*} dirName 
     * @param {Config} config 
     */
    _findProjectFolder(dirName,config) {
        const files = fs.readdirSync(dirName);
        let projectPath = null;
        for(const item of files){
            const fileName = `${dirName}/${item}`;
            const stat = fs.lstatSync(fileName)
            if (stat.isDirectory() === true) {
                const basename = path.basename(fileName);
                if(basename === config.projectFolderName){
                    projectPath = fileName;
                }else if(basename !=='build'){
                    projectPath = this._findProjectFolder(fileName,config);
                }
                if(projectPath){
                    break;
                }
            }
        }
        return projectPath;
    },
    /**
     * 获取工程的目录
     * @param {Config} config 
     */
    getProjectPath(config) {
        const workspaceRootpath = vscode.workspace.rootPath;
        let projectPath = null;
        if(fs.lstatSync(workspaceRootpath).isDirectory() && path.basename(workspaceRootpath) === config.projectFolderName){
            projectPath = workspaceRootpath;
        }else{
            projectPath = this._findProjectFolder(workspaceRootpath,config);
        }

        if (!projectPath) {
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
    // /**
    //  * 获取当前工程名
    //  */
    // getProjectName: function (projectPath) {
    //     return path.basename(projectPath);
    // },
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