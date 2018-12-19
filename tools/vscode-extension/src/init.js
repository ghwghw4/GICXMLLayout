const vscode = require('vscode');
// const StaticServer = require('static-server');
const pathUtils = require('./utils/pathutils');
const fs = require('fs');
const WebSocketServer = require('websocket').server;
const http = require('http');
const watch = require('watch');
const build = require('./buildProject');
const Config = require('./utils/Config');


function init() {
    try {
        // const projectPath = utils.getProjectPath();
        // // 获取配置文件
        // const packageJson = JSON.parse(fs.readFileSync(`${projectPath}/package.json`, 'utf8'));
        startHttpServer(Config.getConfig());
        // watchFiles();
    } catch (error) {
        vscode.window.showErrorMessage('初始化失败，请打开任意文件窗口后，右键从菜单中执行 初始化 指令');
    }
}

let httpServer = null;
let wsServer = null;

// 启动http server
/**
 * 
 * @param {Config} config 
 */
function startHttpServer(config) {
    // 启动http server
    // const buildPath = utils.getBuildPath() + '/project';
    if (httpServer && httpServer.listening) {
        httpServer.close();
    }

    const rootPath = pathUtils.getBuildPath(config) + '/project';
    httpServer = http.createServer(function (request, response) {
        try {
            var bb = fs.readFileSync(rootPath + request.url);
            if (bb && bb != undefined) {
                response.write(bb);
            } else {
                response.writeHead(404);
            }
        } catch (error) {
            response.writeHead(404);
        }
        response.end();
    });
    const port = parseInt(config.httpServerPort);
    httpServer.listen(port, function () {
        vscode.window.showInformationMessage(`http-server 已经启动,端口号:${port},根目录:${rootPath}`);
    });

    // 启动websockt
    wsServer = new WebSocketServer({
        httpServer: httpServer,
        // You should not use autoAcceptConnections for production
        // applications, as it defeats all standard cross-origin protection
        // facilities built into the protocol and the browser.  You should
        // *always* verify the connection's origin and decide whether or not
        // to accept it.
        autoAcceptConnections: false
    });

    wsServer.on('request', function (request) {
        if (!originIsAllowed(request.origin)) {
            // Make sure we only accept requests from an allowed origin
            request.reject();
            console.log((new Date()) + ' Connection from origin ' + request.origin + ' rejected.');
            return;
        }
        var connection = request.accept('gicwatch', request.origin);
        connection.on('message', function (message) {
        });
        // connection.sendUTF('文件改变');
        connection.on('close', function (reasonCode, description) {
        });
    });
}

let monit = null;
/**
 * 监控文件的改变
 */
// function watchFiles() {
//     const root = pathUtils.getProjectPath();
//     if(monit){
//         monit.stop();
//     }
//     watch.createMonitor(root, function (monitor) {
//         monit = monitor
//         monitor.on("created", function (f, stat) {
//             // Handle new files
//             sendFileChangedNotify(f);
//         })
//         monitor.on("changed", function (f, curr, prev) {
//             // Handle file changes
//             sendFileChangedNotify(f);
//         })
//         monitor.on("removed", function (f, stat) {
//             // Handle removed files
//             sendFileChangedNotify(f);
//         })
//     });
// }

function sendFileChangedNotify(fileName){
    build(function(){
        wsServer.connections.forEach(con=>{
            con.sendUTF(JSON.stringify({fileName:fileName}));
        });
    });
}

/**
 * 编译并且通过Websocket发送reload页面的指令
 */
function buildAndRun(){
    build(function(){
        wsServer.connections.forEach(con=>{
            con.sendUTF('reload');
        });
    });
}

function originIsAllowed(origin) {
    // put logic here to detect whether the specified origin is allowed.
    return true;
}

module.exports = function (context) {
    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.init', () => {
        init();
    }));
    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.buildAndRun', () => {
        buildAndRun();
    }));
    init();
};