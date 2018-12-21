const program = require('commander');
const download = require('download-git-repo');
const fs = require('fs');
const path = require('path');
const exec = require('child_process').exec;
const inquirer = require('inquirer');
const chalk = require('chalk');
// const log = console.log;

const autoCreateFolder = [
    'gic',
    'gic/js',
    'gic/elements',
    'gic/behaviors',
    'gic/hotreload',
    'project',
    'project/images',
    'project/js',
    'project/pages',
    'project/style'
];

// 项目配置
const Config = {
    type: 0,
    giturl: '',
    projectName: '',
    completeCallback: null
};

program.version('1.0.0', '-v, --version')
    .command('init <name>')
    .action((projectName) => {
        if (fs.existsSync(projectName)) {
            console.error(`已存在相同名称的项目`);
            return;
        }
        Config.projectName = projectName;
        choiceTemplateType();
    });
program.parse(process.argv);

// 输出红色字体的log
function redColorLog(msg){
    console.log(chalk.red(msg));
}

// 选择模板
function choiceTemplateType() {
    inquirer.prompt([
        {
            type: 'list',
            name: 'type',
            message: '请选择模板类型',
            choices: [
                '1.基础项目模板',
                '2.HotReload',
                '3.HotReload & VSCode',
                '4.HotReload & VSCode & HotUpdate(推荐)',
                // '5.Tabs & HotReload'
            ]
        }
    ]).then((answers) => {
        const type = parseInt(answers.type[0]);
        Config.type = type;
        switch (type) {
            case 1: {
                Config.giturl = 'github:ghwghw4/gic-project-template#base';
                Config.completeCallback = function(){
                    redColorLog(`1.直接使用Xcode编译并且运行应用即可`);
                };
                break;
            }
            case 2: {
                Config.giturl = 'github:ghwghw4/gic-project-template#hotreloading';
                Config.completeCallback = function(){
                    redColorLog(`1.使用命令行进入项目目录(cd ${Config.projectName})`);
                    redColorLog(`2.启动http服务器(base dev-tools.sh)`);
                    redColorLog(`3.使用Xcode编译并且运行工程`);
                };
                break;
            }
            case 3: {
                autoCreateFolder.push('build');
                autoCreateFolder.push('build/project');
                Config.giturl = 'github:ghwghw4/gic-project-template#hotreloading_vscode';
                Config.completeCallback = function(){
                    redColorLog(`1.使用VSCode打开工程文件夹`);
                    redColorLog(`2.在VSCode中搜索'GICVSCodeExtension'插件并且安装`);
                    redColorLog(`3.使用'cmd+b'快捷键编译project文件夹，VSCode会在build目录中生成编译后的文件`);
                    redColorLog(`4.使用Xcode编译并且运行工程`);
                };
                break;
            }
            case 4: {
                autoCreateFolder.push('build');
                autoCreateFolder.push('build/project');
                Config.giturl = 'github:ghwghw4/gic-project-template#hotreloading_vscode_hotupdate';
                Config.completeCallback = function(){
                    redColorLog(`1.使用VSCode打开工程文件夹`);
                    redColorLog(`2.在VSCode中搜索'GICVSCodeExtension'插件并且安装`);
                    redColorLog(`3.使用'cmd+b'快捷键编译project文件夹，VSCode会在build目录中生成编译后的文件`);
                    redColorLog(`4.使用Xcode编译并且在模拟器中运行工程`);
                    redColorLog(`5.试着修改project文件夹下的package.json中的版本号，并且修改页面部分内容，然后点击应用中的‘检查更新’按钮`);
                };
                break;
            }
            default:
                break;
        }

        beginDowbload();
    })
}

function beginDowbload() {
    console.log('download template ...');
    download(Config.giturl, Config.projectName, { clone: false }, (err) => {
        if (!err) {
            replaceTemplate(Config.projectName);
            fs.renameSync(`${Config.projectName}/${Config.projectName}`,'.temp');
            fs.rmdirSync(Config.projectName);
            fs.renameSync('.temp',Config.projectName);
            // 生成文件夹
            createFolder();
            // 执行指令
            podUpdate();
        } else {
            console.error(err);
        }
    });
}

/**
 * 替换模板
 * @param {*} folderName 
 * @param {*} projectName 
 */
function replaceTemplate(folderName) {
    const files = fs.readdirSync(folderName);
    files.forEach(function (item, index) {
        const fileName = `${folderName}/${item}`;
        const stat = fs.lstatSync(fileName)
        if (stat.isDirectory() === true) {
            replaceTemplate(fileName);
            // 重命名文件夹
            const baseName = replaceString(path.basename(fileName));
            const dirName = path.dirname(fileName);
            fs.renameSync(fileName, `${dirName}/${baseName}`);
        } else if (stat.isFile) {
            let content = fs.readFileSync(fileName, 'utf8');
            content = replaceString(content);
            fs.writeFileSync(fileName, content);
        }
    });
}

function replaceString(str) {
    return str.replace(/GICTemplate/g, Config.projectName);
}



function createFolder() {
    autoCreateFolder.forEach(name => {
        const fileName = `${Config.projectName}/${Config.projectName}/${name}`;
        if (!fs.existsSync(fileName)) {
            fs.mkdirSync(fileName);
        }
    });
}

function podUpdate() {
    console.log('pod install ...');
    // \n open ${Config.projectName}.xcworkspace
    exec(`cd ${Config.projectName} \n pod install`, () => {
        console.log('process complete');
        console.log(chalk.blue(`请继续下面的步骤`));
        if(Config.completeCallback){
            Config.completeCallback();
        }
    });
}
