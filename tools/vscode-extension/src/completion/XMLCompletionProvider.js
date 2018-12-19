const BaseCompletionProvider = require('./BaseCompletionProvider');
const vscode = require('vscode');
const CompletionConfig = require('./CompletionConfig');

class XMLCompletionProvider extends BaseCompletionProvider {
    /**
     * 从配置文件中寻找匹配的元素名称
     * @param {*} elementName 
     * @param {CompletionConfig} config 
     */
    findElementConfigFromElementName(elementName,config) {
        let findEl = null;
        config.elements.forEach(el => {
            if (el.elementName === elementName) {
                findEl = el;
            } else if (el.subElements) {
                let tmp = this._findElmentElementName(el, elementName);
                if (tmp) {
                    findEl = tmp;
                }
            }
        });
        return findEl;
    }

    _findElmentElementName(parent, elementName) {
        let findEl = null;
        if(parent.subElements){
            parent.subElements.forEach(el => {
                if (el.elementName === elementName) {
                    findEl = el;
                } else if (el.subElements) {
                    let tmp = this._findElmentElementName(el, elementName);
                    if (tmp) {
                        findEl = tmp;
                    }
                }
            });
        }
        return findEl;
    }

     /**
     * 
     * @param {string} linetext 
     */
    getElementNameFromLineText(linetext) {
        const p1 = linetext.indexOf('<');
        const p2 = linetext.indexOf(' ');
        return linetext.substring(p1 + 1, p2);
    }

    /**
     * 
     * @param {*} elementName 
     * @param {CompletionConfig} config 
     */
    findElementAttributsFromElementName(elementName,config){
        let findEl = this.findElementConfigFromElementName(elementName,config);
        let attributes = [].concat(config.commonAttributes).concat(findEl.attributes);
        if (findEl.isui) {//只有UI元素才会具备通用UI属性
            attributes = attributes.concat(config.commonUIAttributes);
        }
        if (findEl.isAnimation) {
            attributes = attributes.concat(config.commonAnimationAttributs);
        }
        return attributes;
    }

    // /**
    //  * 获取当前行的元素名称
    //  * @param {string} lineString 
    //  */
    // getElementNameFromLineString(lineString) {
    //     const reg = /<([\s\S]+)/;
    //     const result = reg.exec(lineString);
    //     if (result.length == 2) {
    //         return result[1];
    //     }
    //     return null;
    // }
}

module.exports = XMLCompletionProvider;