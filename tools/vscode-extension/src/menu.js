const vscode = require('vscode');
const BuildProject = require('./buildProject');

module.exports = function (context) {
    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.buildjs', () => {
        BuildProject.build();
    }));

    context.subscriptions.push(vscode.commands.registerCommand('extension.gic.buildAndZip', () => {
        BuildProject.buildAndZip();
    }));
};