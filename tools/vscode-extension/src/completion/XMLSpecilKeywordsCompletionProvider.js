const BaseCompletionProvider = require('./BaseCompletionProvider');
const vscode = require('vscode');

class XMLSpecilKeywordsCompletionProvider extends BaseCompletionProvider {
    provideCompletionItems(document, position, token, context) {
        const config = this.getConfig();
        let completionItems = [];
        config.xmlSpeceilKeywords.forEach(item => {
            let completionItem = new vscode.CompletionItem(item.name);
            completionItem.kind = vscode.CompletionItemKind.Keyword;
            completionItem.detail = item.desc;
            completionItem.insertText = item.value;
            completionItems.push(completionItem);
        });
        return completionItems;
    }
}

module.exports = XMLSpecilKeywordsCompletionProvider;