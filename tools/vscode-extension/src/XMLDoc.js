const xml2js = require('xml2js');

class XMLNode {
    static parse(xmlstring) {
        let parser = new xml2js.Parser();
        let xmldoc = null;
        parser.parseString(xmlstring, (err, result) => {
            if (null === err) {
                let rootName = Object.keys(result)[0];
                xmldoc = new XMLNode(result[rootName],rootName);
            }
        });
        return xmldoc;
    }
    /**
     * 
     * @param {*} element 
     */
    constructor(element,name) {
        this.name = name;
        this.subNodes = [];
        this.parentNode = null;
        this._parseSubNodes(element);
    }

    _parseSubNodes(_element){
        Object.keys(_element).forEach(k=>{
            if(_element[k] instanceof Array){
                _element[k].forEach(el=>{
                    const node = new XMLNode(el,k);
                    node.parentNode = this;
                    this.subNodes.push(node);
                });
            }
        });
    }
}


module.exports = XMLNode;