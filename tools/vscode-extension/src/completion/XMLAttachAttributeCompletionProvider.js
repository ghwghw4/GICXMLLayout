const XMLCompletionProvider = require('./XMLCompletionProvider');
const vscode = require('vscode');

// 附加属性
class XMLAttachAttributeCompletionProvider extends XMLCompletionProvider {
    provideCompletionItems(document, position, token, context) {
        const config = this.getConfig();
        const lineText = this.ltrimString(document.lineAt(position).text.substring(0, position.character));
        const spaceIndex = lineText.lastIndexOf(' ');
        const elementName = lineText.substring(spaceIndex+1,lineText.length-1);
        const el = this.findElementConfigFromElementName(elementName,config);
        let completionItems = [];
        el.attachAttributes.forEach(el => {
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

    /**
     * 
     * @param {string} linetext 
     */
    getAttributeNameFromLineText(linetext) {
        const p1 = linetext.lastIndexOf(' ');
        const p2 = linetext.lastIndexOf('=');
        return linetext.substring(p1 + 1, p2);
    }
}

module.exports = XMLAttachAttributeCompletionProvider;