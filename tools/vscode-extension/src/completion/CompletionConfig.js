const vscode = require('vscode');
const Config = require('../utils/Config');
const fs = require('fs');

class CompletionConfig{
    constructor(){
        const configJson =JSON.parse(fs.readFileSync(`${vscode.extensions.getExtension("gonghaiwei.gicvscodeextension").extensionPath}/src/completion/Config.json`,'utf8'));
        const localConfig = Config.getConfig();

        this.colors = configJson.colors;
        this.keywords = configJson.JSKeywords;
        this.ignorElementsName = configJson.ignorElementsName;
        this.commonAttributes = configJson.commonAttributes;
        this.commonUIAttributes = configJson.commonUIAttributes;
        this.commonAnimationAttributs = configJson.commonAnimationAttributs;
        this.xmlSpeceilKeywords = configJson.xmlSpeceilKeywords;

        this.elements = configJson.elements;
        if(!(localConfig.elements.length===1 && localConfig.elements[0].elementName==='elementName')){
            this.elements = configJson.elements.concat(localConfig.elements);
        }

        if(!(localConfig.behaviors.length===1 && localConfig.behaviors[0].elementName==='elementName')){
            for(let item of this.elements){
                if(item.elementName==='behaviors'){
                    item.subElements = item.subElements.concat(localConfig.behaviors);
                }
            }
        }
    }
}
module.exports = CompletionConfig;