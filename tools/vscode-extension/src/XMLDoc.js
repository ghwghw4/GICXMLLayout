// const xml2js = require('xml2js');
const xmlParser = require('xml-parser');
var XMLWriter = require('xml-writer');

class XMLNode {
    /**
     * 
     * @param {*} xmlstring 
     * @returns {XMLNode}
     */
    static parse(xmlstring) {
        let xml= xmlParser(xmlstring);
        let xmldoc = null;
        if(xml){
            xmldoc = new XMLNode(xml.root);
        }
        return xmldoc;
    }

    /**
     * 
     * @param {XMLNode} xmlnode 
     */
    static write(xmlnode){
        const xw = new XMLWriter();
        xw.startDocument();
        xmlnode.write(xw);
        xw.endDocument();
        return xw.toString();
    }
   
    constructor(xmlNode) {
        if(xmlNode === undefined){
            console.log();
        }
        this.name = xmlNode.name;
        this.subNodes = [];
        this.parentNode = null;
        this.attributes = xmlNode.attributes;
        this.content = xmlNode.content;
        if(xmlNode.children){
            this._parseSubNodes(xmlNode.children);
        }
    }

    _parseSubNodes(nodes){
        nodes.forEach(node=>{
            const sub = new XMLNode(node);
            sub.parentNode = this;
            this.subNodes.push(sub);
        });
    }

    /**
     * 
     * @param {XMLWriter} xw 
     */
    write(xw){
        xw.startElement(this.name);
        Object.keys(this.attributes).forEach(k=>{
            xw.writeAttribute(k, this.attributes[k]);
        });

        if(this.content && this.content.length>0){
            xw.text(this.content);
        }

        this.subNodes.forEach(node=>{
            node.write(xw);
        });
        xw.endElement();
    }
}


module.exports = XMLNode;