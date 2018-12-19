const XMLCompletionProvider = require('./XMLCompletionProvider');
const vscode = require('vscode');

class XMLAttributeValueCompletionProvider extends XMLCompletionProvider{
    provideCompletionItems(document, position, token, context) {
        const config = this.getConfig();
        const lineText = this.ltrimString(document.lineAt(position).text.substring(0, position.character));
        const elementName = this.getElementNameFromLineText(lineText);
        const attributes = this.findElementAttributsFromElementName(elementName,config);
        const attName = this.getAttributeNameFromLineText(lineText);
        return this.matchAttributeName(attName,attributes,config);
    }

    /**
     * 
     * @param {*} attName 
     * @param {*} attributes 
     * @param {*} config 
     */
    matchAttributeName(attName, attributes,config) {
        let findAtt = null;
    
        let completionItems = [];
        attributes.forEach(el => {
            if (el && el.name === attName) {
                findAtt = el;
            }
        });
        if (findAtt) {
            const valueType = findAtt.type;
            switch (valueType) {
                case 'bool': {
                    completionItems.push(new vscode.CompletionItem("true"));
                    completionItems.push(new vscode.CompletionItem("false"));
                    break;
                }
                case 'color': {
                    config.colors.forEach(e => {
                        completionItems.push(new vscode.CompletionItem(e));
                    });
                    break;
                }
                case 'enum': {
                    findAtt.enums.forEach(e => {
                        const completionItem = new vscode.CompletionItem(e.name);
                        completionItem.kind = vscode.CompletionItemKind.Enum;
                        completionItem.detail = e.desc;
                        completionItem.insertText = `${e.value}`;
                        completionItems.push(completionItem);
                    });
                    break;
                }
                default: {
                    break;
                }
            }
        }
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

module.exports = XMLAttributeValueCompletionProvider;