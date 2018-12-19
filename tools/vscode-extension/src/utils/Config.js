const vscode = require('vscode');

class Config{
    /**
     * 
     * @param {vscode.WorkspaceConfiguration} configuration 
     */
    constructor(configuration){
        this.httpServerPort = configuration.get('httpServerPort');
        this.elements = configuration.get('elements');
        this.behaviors = configuration.get('behaviors');
        this.projectFolderName = configuration.get('projectFolderName');
    }

    static getConfig(){
        const configuration = vscode.workspace.getConfiguration('GICXMLLayout');
        return new Config(configuration);
    }
}
module.exports = Config;