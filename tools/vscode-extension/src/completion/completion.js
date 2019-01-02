const vscode = require('vscode');

const PathCompletionProvider = require('./PathCompletionProvider');
const KeywordComplationProvider = require('./KeywordComplationProvider');
const XMLTagCompletionProvider = require('./XMLTagCompletionProvider');
const XMLAttributeCompletionProvider = require('./XMLAttributeCompletionProvider');
const XMLAttributeValueCompletionProvider = require('./XMLAttributeValueCompletionProvider');
const XMLSpecilKeywordsCompletionProvider = require('./XMLSpecilKeywordsCompletionProvider');
const XMLAttachAttributeCompletionProvider = require('./XMLAttachAttributeCompletionProvider');


const configJson = require(`${vscode.extensions.getExtension("gonghaiwei.gicvscodeextension").extensionPath}/src/completion/Config.json`);
module.exports = function (context) {
    // 注册代码建议提示
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('*', new PathCompletionProvider(), '/'));
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('xml', new KeywordComplationProvider(), '$'));
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('xml', new XMLTagCompletionProvider(), '<'));
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('xml', new XMLAttributeCompletionProvider(), ' '));
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('xml', new XMLAttributeValueCompletionProvider(), '"'));
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('xml', new XMLSpecilKeywordsCompletionProvider(), '&'));
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('xml', new XMLAttachAttributeCompletionProvider(), '.'));
};