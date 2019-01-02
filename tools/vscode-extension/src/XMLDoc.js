// const xml2js = require('xml2js');
const xmlParser = require('./utils/xmlParser');
var XMLWriter = require('xml-writer');
const pathutils = require('./utils/pathutils');

/**
 * 替换XMLWriter中的text方法，主要是为了避免被替换特殊字符
 * @param {string} content 
 */
const NewTextFunc = function (content) {
    if (!this.tags && !this.comment && !this.pi && !this.cdata) return this;
    if (this.attributes && this.attribute) {
        ++this.texts;
        this.write(content);
        return this;
    } else if (this.attributes && !this.attribute) {
        this.endAttributes();
    }
    if (this.comment || this.cdata) {
        this.write(content);
    }
    else {
        this.write(content.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'));
    }
    ++this.texts;
    this.started_write = true;
    return this;
};

class XMLNode {
    /**
     * 
     * @param {*} xmlstring 
     * @returns {XMLNode}
     */
    static parse(xmlstring) {
        let xml = xmlParser(xmlstring);
        let xmldoc = null;
        if (xml) {
            xmldoc = new XMLNode(xml.root);
        }
        return xmldoc;
    }

    /**
     * 
     * @param {XMLNode} xmlnode 
     */
    static write(xmlnode,fileName) {
        const xw = new XMLWriter();
        xw.fileName = fileName;
        xw.text = NewTextFunc;
        xw.startDocument();
        xmlnode.write(xw);
        xw.endDocument();
        return xw.toString();
    }

    constructor(xmlNode) {
        if (xmlNode === undefined) {
            console.log();
        }
        this.name = xmlNode.name;
        this.subNodes = [];
        this.parentNode = null;
        this.attributes = xmlNode.attributes;
        this.content = xmlNode.content;
        if (xmlNode.children) {
            this._parseSubNodes(xmlNode.children);
        }
    }

    _parseSubNodes(nodes) {
        nodes.forEach(node => {
            const sub = new XMLNode(node);
            sub.parentNode = this;
            this.subNodes.push(sub);
        });
    }

    /**
     * 
     * @param {XMLWriter} xw 
     */
    write(xw) {
        xw.startElement(this.name);
        Object.keys(this.attributes).forEach(k => {
            xw.writeAttribute(k, pathutils.resolveFilePath(xw.fileName,this.attributes[k]));
        });

        if (this.content && this.content.length > 0) {
            xw.text(this.content);
        }

        this.subNodes.forEach(node => {
            node.write(xw);
        });
        xw.endElement();
    }
}


module.exports = XMLNode;