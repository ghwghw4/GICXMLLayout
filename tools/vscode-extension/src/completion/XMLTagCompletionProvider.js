const XMLCompletionProvider = require('./XMLCompletionProvider');
const vscode = require('vscode');
const XMLNode = require('../XMLDoc');

/**
 * XML 标签名称的提示
 */
class XMLTagCompletionProvider extends XMLCompletionProvider {
    provideCompletionItems(document, position, token, context) {
        const config = this.getConfig();
        let elements = [].concat(config.elements);
        { // 判断是否支持子元素
            let doc = this.readTempDoc(document, position);
            let parentElementName = null;
            let xmldoc = XMLNode.parse(doc);
            if (xmldoc) {
                this.findTempElement(xmldoc, (node) => {
                    let ignor = false;
                    // 避免出现在 for if 等指令内的时候发生错误提示
                    config.ignorElementsName.forEach(item => {
                        if (item === node.name) {
                            ignor = true;
                        }
                    });
                    if (ignor) {
                        node = node.parentNode;
                    }
                    if (node) {
                        parentElementName = node.name;
                    }
                });
            }

            if (parentElementName) {
                // 检查父元素是否有子元素的额外配置
                let findEl = this.findElementConfigFromElementName(parentElementName,config);
                if (findEl && findEl.subElements) {
                    if (findEl.special) {// 如果是特殊元素，那么子元素只能出现自己定义的子元素
                        elements = [];
                        config.elements.forEach(item => {
                            if (item.idDirective) {// 指令可以无条件出现在任何元素中
                                elements.push(item);
                            }
                        });
                    }
                    elements = elements.concat(findEl.subElements);
                }
            }
        }

        let completionItems = [];
        elements.forEach(element => {
            let completionItem = new vscode.CompletionItem(element.elementName);
            completionItem.kind = vscode.CompletionItemKind.Class;
            completionItem.detail = element.desc;
            completionItem.insertText = element.elementName;
            completionItems.push(completionItem);
        });
        return completionItems;
    }

    readTempDoc(document, position) {
        let doc = '';
        for (let i = 0; i < document.lineCount; i++) {
            if (i === position.line) {
                doc += '<temp-element></temp-element>';
            } else {
                doc += document.lineAt(new vscode.Position(i, 100000)).text;
            }
        }
        return doc;
    }

    /**
     * 
     * @param {XMLNode} node 
     * @param {*} cb 
     */
    findTempElement(node, cb) {
        node.subNodes.forEach(n => {
            if (n.name === 'temp-element') {
                cb(n.parentNode);
            } else {
                this.findTempElement(n, cb);
            }
        });
    }
}

module.exports = XMLTagCompletionProvider;