const fs = require('fs');
const os = require('os');
const path = require('path');
const vscode = require('vscode');
const exec = require('child_process').exec;

const util = {
    /**
     * 将一个单词首字母大写并返回
     * @param {*} word 某个字符串
     */
    upperFirstLetter: function (word) {
        return (word || '').replace(/^\w/, m => m.toUpperCase());
    },
    /**
     * 将一个单词首字母转小写并返回
     * @param {*} word 某个字符串
     */
    lowerFirstLeter: function (word) {
        return (word || '').replace(/^\w/, m => m.toLowerCase());
    },
    /**
     * 全局日志开关，发布时可以注释掉日志输出
     */
    log: function (...args) {
        console.log(...args);
    },
    /**
     * 全局日志开关，发布时可以注释掉日志输出
     */
    error: function (...args) {
        console.error(...args);
    },
    /**
     * 弹出错误信息
     */
    showError: function (info) {
        vscode.window.showErrorMessage(info);
    },
    /**
     * 弹出提示信息
     */
    showInfo: function (info) {
        vscode.window.showInformationMessage(info);
    },
    findStrInFolder: function (folderPath, str) {

    },
    /**
     * 从某个文件里面查找某个字符串，返回第一个匹配处的行与列，未找到返回第一行第一列
     * @param filePath 要查找的文件
     * @param reg 正则对象，最好不要带g，也可以是字符串
     */
    findStrInFile: function (filePath, reg) {
        const content = fs.readFileSync(filePath, 'utf-8');
        reg = typeof reg === 'string' ? new RegExp(reg, 'm') : reg;
        // 没找到直接返回
        if (content.search(reg) < 0) return { row: 0, col: 0 };
        const rows = content.split(os.EOL);
        // 分行查找只为了拿到行
        for (let i = 0; i < rows.length; i++) {
            let col = rows[i].search(reg);
            if (col >= 0) {
                return { row: i, col };
            }
        }
        return { row: 0, col: 0 };
    },
    /**
     * 获取某个字符串在文件里第一次出现位置的范围，
     */
    getStrRangeInFile: function (filePath, str) {
        var pos = this.findStrInFile(filePath, str);
        return new vscode.Range(new vscode.Position(pos.row, pos.col), new vscode.Position(pos.row, pos.col + str.length));
    },
    /**
     * 简单的检测版本大小
     * @param {string} version1 
     * @param {string} version2 
     */
    checkVersion: function (version1, version2) {
        if(version1 === version2){
            return false;
        }
        const v1 = version1.split('.');
        const v2 = version2.split('.');
        for(let i=0;i<v1.length;i++){
            if(parseInt(v1[i])<parseInt(v2[i])){
                return false;
            }
        }
        return true
    },
    /**
     * 获取某个扩展文件绝对路径
     * @param context 上下文
     * @param relativePath 扩展中某个文件相对于根目录的路径，如 images/test.jpg
     */
    getExtensionFileAbsolutePath: function (context, relativePath) {
        return path.join(context.extensionPath, relativePath);
    },
    /**
     * 获取某个扩展文件相对于webview需要的一种特殊路径格式
     * 形如：vscode-resource:/Users/toonces/projects/vscode-cat-coding/media/cat.gif
     * @param context 上下文
     * @param relativePath 扩展中某个文件相对于根目录的路径，如 images/test.jpg
     */
    getExtensionFileVscodeResource: function (context, relativePath) {
        const diskPath = vscode.Uri.file(path.join(context.extensionPath, relativePath));
        return diskPath.with({ scheme: 'vscode-resource' }).toString();
    },
    /**
     * 在Finder中打开某个文件或者路径
     */
    openFileInFinder: function (filePath) {
        if (!fs.existsSync(filePath)) {
            this.showError('文件不存在：' + filePath);
        }
        // 如果是目录，直接打开就好
        if (fs.statSync(filePath).isDirectory()) {
            exec(`open ${filePath}`);
        } else {
            // 如果是文件，要分开处理
            const fileName = path.basename(filePath);
            filePath = path.dirname(filePath);
            // 这里有待完善，还不知道如何finder中如何选中文件
            exec(`open ${filePath}`);
        }
    },
    /**
     * 在vscode中打开某个文件
     * @param {*} path 文件绝对路径
     * @param {*} text 可选，如果不为空，则选中第一处匹配的对应文字
     */
    openFileInVscode: function (path, text) {
        let options = undefined;
        if (text) {
            const selection = this.getStrRangeInFile(path, text);
            options = { selection };
        }
        vscode.window.showTextDocument(vscode.Uri.file(path), options);
    },
    /**
     * 用JD-GUI打开jar包
     */
    openJarByJdGui: function (jarPath) {
        // 如何选中文件有待完善
        const jdGuiPath = vscode.workspace.getConfiguration().get('eggHelper.jdGuiPath');
        if (!jdGuiPath) {
            this.showError('JD-GUI路径不能为空！');
            return;
        }
        if (!fs.existsSync(jdGuiPath)) {
            this.showError('您还没有安装JD-GUI，请安装完后到vscode设置里面找到HSF助手并进行路径配置。');
            return;
        }
        if (!fs.existsSync(jarPath)) {
            this.showError('jar包未找到：' + jarPath);
            return;
        }
        exec(`open ${jarPath} -a ${jdGuiPath}`);
    },
    /**
     * 使用默认浏览器中打开某个URL
     */
    openUrlInBrowser: function (url) {
        exec(`open '${url}'`);
    },
    /**
     * 递归遍历清空某个资源的require缓存
     * @param {*} absolutePath
     */
    clearRequireCache(absolutePath) {
        const root = require.cache[absolutePath];
        if (!root) return;
        if (root.children) {
            // 如果有子依赖项，先清空依赖项的缓存
            root.children.forEach(item => {
                this.clearRequireCache(item.id);
            });
        }
        delete require.cache[absolutePath];
    },
    /**
     * 动态require，和普通require不同的是，加载之前会先尝试删除缓存
     * @param {*} modulePath 
     */
    dynamicRequire(modulePath) {
        this.clearRequireCache(modulePath);
        return require(modulePath);
    },
    /**
     * 读取properties文件
     * @param {*} filePath 
     */
    readProperties(filePath) {
        const content = fs.readFileSync(filePath, 'utf-8');
        let rows = content.split(os.EOL);
        rows = rows.filter(row => row && row.trim() && !/^#/.test(row));
        const result = {};
        rows.forEach(row => {
            let temp = row.split('=');
            result[temp[0].trim()] = temp[1].trim();
        });
        return result;
    },
    /**
     * 比较2个对象转JSON字符串后是否完全一样
     * 特别注意，由于JS遍历对象的无序性（部分浏览器是按照添加顺序遍历的）导致同样的对象，
     * 转成JSON串之后反而不一样，所以这里采用其它方式实现。
     * @param {*} obj1 
     * @param {*} obj2 
     */
    jsonEquals(obj1, obj2) {
        let s1 = this.formatToSpecialJSON(obj1, '', true);
        let s2 = this.formatToSpecialJSON(obj2, '', true);
        return s1 === s2;
    }
};

module.exports = util;