const vscode = require('vscode');
const CompletionConfig = require('./CompletionConfig');

class BaseCompletionProvider {
    constructor(){
        // this.extentionCompletionConfig = extentionCompletionConfig;
        // this.extensionConfig = extensionConfig;
    }
    /**
     * 
     * @param {vscode.TextDocument} document 
     * @param {vscode.Position} position 
     * @param {vscode.CancellationToken} token 
     * @param {vscode.CompletionContext} context 
     */
    provideCompletionItems(document, position, token, context) {

    }

    /**
     * 移除字符串左边的空格
     * @param {*} str 
     */
    ltrimString(str) {
        return str.replace(/(^\s*)/g, "");
    }

    /**
     * 移除字符串右边的空格
     * @param {*} str 
     */
    rtrimString(str) {
        return str.replace(/(\s*$)/g, "");
    }

    /**
     * 移除字符串左右两边的空格
     * @param {*} str 
     */
    trimString(str) {
        return this.ltrimString(this.rtrimString(str));
    }

    getConfig(){
        return new CompletionConfig();
    }
}

module.exports = BaseCompletionProvider;