const vscode = require('vscode');
const xml2js = require('xml2js');
const util = require('../util');
const fs = require('fs');
const path = require('path');
const XMLNode = require('../XMLDoc');

const configJson = require(`${vscode.extensions.getExtension("龚海伟.gicvscodeextension").extensionPath}/src/completion/Config.json`);

String.prototype.ltrim = function () {
    return this.replace(/(^\s*)/g, "");
}

/**
 * 
 * @param {XMLNode} node 
 * @param {*} cb 
 */
function findTempElement(node, cb) {
    node.subNodes.forEach(n => {
        if (n.name === 'temp-element') {
            cb(n.parentNode);
        } else {
            findTempElement(n, cb);
        }
    });
    // if(node.name ==)
    // node.subNodes
    // Object.keys(element).forEach(k=>{
    //     if((element[k] instanceof Array)){
    //         element[k].forEach((el)=>{
    //             if(el['temp-element']){
    //                 cb(k);
    //             }else{
    //                 findTempElement(el,cb);
    //             }
    //         });
    //     }
    // });
}

/**
 * 自动提示实现
 * @param {*} document 
 * @param {*} position 
 * @param {*} token 
 * @param {*} context 
 */
function provideCompletionItems(document, position, token, context) {
    const line = document.lineAt(position);
    // 只截取到光标位置为止，防止一些特殊情况
    const lineText = line.text.substring(0, position.character).ltrim();
    if(lineText[lineText.length - 1] === '$'){ //
        let completionItems = []; 
        configJson.JSKeywords.forEach(item => {
            let completionItem = new vscode.CompletionItem(item.name);
            completionItem.kind = vscode.CompletionItemKind.Keyword;
            completionItem.detail = item.desc;
            completionItem.insertText = item.name;
            completionItems.push(completionItem);
        });
        return completionItems;
    }
    const strs = lineText.split(' ');
    if (strs.length === 1) {
        let elements = [].concat(configJson.elements);
        { // 判断是否支持子元素
            let doc = document.getText(new vscode.Range(new vscode.Position(0, 0), new vscode.Position(document.lineCount, 10000)));
            // 删除当前行的文本
            doc = doc.replace(line.text, '<temp-element></temp-element>');
            let parentElementName = null;
            let xmldoc = XMLNode.parse(doc);
            if (xmldoc) {
                findTempElement(xmldoc, (node) => {
                    let ignor = false;
                    // 避免出现在 for if 等指令内的时候发生错误提示
                    configJson.ignorElementsName.forEach(item => {
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
                let findEl = findElmentConfigFromElementName(parentElementName);
                if (findEl && findEl.subElements) {
                    if (findEl.special) {// 如果是特殊元素，那么子元素只能出现自己定义的子元素
                        elements = [];
                        configJson.elements.forEach(item=> {
                            if(item.idDirective){// 指令可以无条件出现在任何元素中
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
    } else if (strs.length > 1) {
        // 正则表达式匹配元素名称
        const elementName = getElementNameFromLineString(strs[0]);
        if (elementName) {
            return matchElementAttributs(elementName, strs[strs.length - 1]);
        }
    }
    return null;
}


function _findElmentElementName(parent, elementName) {
    let findEl = null;
    parent.subElements.forEach(el => {
        if (el.elementName === elementName) {
            findEl = el;
        } else if (el.subElements) {
            let tmp = _findElmentElementName(el, elementName);
            if (tmp) {
                findEl = tmp;
            }
        }
    });
    return findEl;
}

function findElmentConfigFromElementName(elementName) {
    let findEl = null;
    configJson.elements.forEach(el => {
        if (el.elementName === elementName) {
            findEl = el;
        } else if (el.subElements) {
            let tmp = _findElmentElementName(el, elementName);
            if (tmp) {
                findEl = tmp;
            }
        }
    });
    return findEl;
}

function getElementNameFromLineString(lineString) {
    const reg = /<([\s\S]+)/;
    const result = reg.exec(lineString);
    if (result.length == 2) {
        return result[1];
    }
    return null;
}


function matchElementAttributs(elementName, lastAttributeString) {
    let findEl = findElmentConfigFromElementName(elementName);
    if (findEl) {
        const lastChar = lastAttributeString[lastAttributeString.length - 1];
        let attributes = [].concat(configJson.commonAttributes).concat(findEl.attributes);
        if (findEl.isui) {//只有UI元素才会具备通用UI属性
            attributes = attributes.concat(configJson.commonUIAttributes);
        }
        if (findEl.isAnimation) {
            attributes = attributes.concat(configJson.commonAnimationAttributs);
        }
        if (lastChar === '"' || lastChar === "'") {
            // 说明是在填入属性内容
            // 提取属性名称
            return matchAttributeName(lastAttributeString, findEl, attributes);
        } else {
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
                }
            });
            return completionItems;
        }
    }
    return null;
}

/**
 * 匹配属性自动填充内容
 * @param {*} attStr 
 * @param {*} elementConfig 
 */
function matchAttributeName(attStr, elementConfig, attributes) {
    const reg = /.+?(?==)/;
    const result = reg.exec(attStr);
    const attName = result[0];
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
                configJson.colors.forEach(e => {
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
 * 光标选中当前自动补全item时触发动作，一般情况下无需处理
 * @param {*} item 
 * @param {*} token 
 */
function resolveCompletionItem(item, token) {
    return null;
}

module.exports = function (context) {
    // 注册代码建议提示，只有当按下“.”时才触发
    context.subscriptions.push(vscode.languages.registerCompletionItemProvider('xml', {
        provideCompletionItems,
        resolveCompletionItem
    }, '<', ' ', '"', "'",'$'));
};