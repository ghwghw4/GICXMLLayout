const path = require('path');
const fs = require('fs');
const vscode = require('vscode');
const pathUtil = require('../utils/pathutils');
const Config = require('../utils/Config');

const BaseCompletionProvider = require('./BaseCompletionProvider');

class PathCompletionProvider extends BaseCompletionProvider{
    provideCompletionItems(document, position, token, context) {
        const textCurrentLine = document.getText(document.lineAt(position).range);
        const textWithinString = this.getTextWithinString(textCurrentLine, position.character);
        const projectPath = pathUtil.getProjectPath(Config.getConfig());
        const completionPath = pathUtil.getAbsolutePath(document.fileName, textWithinString, projectPath);
        let completionItems = [];
        const files = fs.readdirSync(completionPath);
        files.forEach(function (item, index) {
            const fileName = `${completionPath}/${item}`;
            const stat = fs.lstatSync(fileName);
            const basename = path.basename(fileName);
            let completionItem = new vscode.CompletionItem(basename);
            completionItem.detail = basename;
            completionItem.insertText = basename;
           
            if (stat.isDirectory() === true) {
                completionItem.kind = vscode.CompletionItemKind.Folder;
                completionItems.push(completionItem);
                // 允许链式提示的关键
                completionItem.command = {
                    command: 'default:type',
                    title: 'triggerSuggest',
                    arguments: [{
                        text: '/'
                    }]
                };
            } else if (stat.isFile) {
                completionItem.kind = vscode.CompletionItemKind.File;
                completionItems.push(completionItem);
            }
        });
        return completionItems;
    }

    getTextWithinString(text, position) {
        const textToPosition = text.substring(0, position);
        const quoatationPosition = Math.max(textToPosition.lastIndexOf('\"'), textToPosition.lastIndexOf('\''), textToPosition.lastIndexOf('\`'));
        return quoatationPosition != -1 ? textToPosition.substring(quoatationPosition + 1, textToPosition.length) : undefined;
    }
}

module.exports = PathCompletionProvider;

// module.exports = function (context) {
//     // 注册代码建议提示
//     context.subscriptions.push(vscode.languages.registerCompletionItemProvider('*', new PathCompletionProvider(), '/', '\''));
// };