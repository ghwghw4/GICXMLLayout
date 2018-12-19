const XMLCompletionProvider = require('./XMLCompletionProvider');
const vscode = require('vscode');

class XMLAttributeCompletionProvider extends XMLCompletionProvider {
    provideCompletionItems(document, position, token, context) {
        const config = this.getConfig();
        const lineText = this.ltrimString(document.lineAt(position).text.substring(0, position.character));
        const elementName = this.getElementNameFromLineText(lineText);
        const attributes = this.findElementAttributsFromElementName(elementName,config);
        let completionItems = [];
        attributes.forEach(el => {
            if (el) {
                let completionItem = new vscode.CompletionItem(el.name);
                completionItem.kind = vscode.CompletionItemKind.Property;
                if (el.type === 'event') {
                    completionItem.kind = vscode.CompletionItemKind.Event;
                }
                completionItem.detail = el.desc;
                completionItem.insertText = el.name + '=';
                completionItems.push(completionItem);
                completionItem.command = {
                    command: 'default:type',
                    title: 'triggerSuggest',
                    arguments: [{
                        text: '"'
                    }]
                };
            }
        });
        return completionItems;
    }
}

module.exports = XMLAttributeCompletionProvider;