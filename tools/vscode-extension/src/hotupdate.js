const fs = require('fs');
const pathutils = require('./utils/pathutils');
const Config = require('./utils/Config');
const utils = require('./utils/util');
const URL = require('url');
const qs = require('querystring');
const BuildProject = require('./buildProject');

// 热更新测试模块
/**
 * 热更新测试模块
 */
module.exports = async function (url) {
    const lastPackageInfo = JSON.parse(fs.readFileSync(`${pathutils.getProjectPath(Config.getConfig())}/package.json`, 'utf8'));
    const params = qs.parse(url.query);
    const rsp = { code: 200 };
    if(Object.keys(params).length === 0){
        rsp.code = 201;
        rsp.msg = '缺少参数';
    }else{
        if(params.updatePackege){
            await BuildProject.buildAndZip();
            const fileName = `${pathutils.getBuildPath(Config.getConfig())}/project.zip`;
            const content = fs.readFileSync(fileName);
            return content;
        }
        if(lastPackageInfo.needAppVersion === params.appVersion){
            if(utils.checkVersion(lastPackageInfo.version,params.packgeVersion)){
                rsp.data = {packageVersion:lastPackageInfo.version,packageUrl:`http://${url.host}/hotupdate.php?updatePackege=true`};
            }
        }
    }
    
    return JSON.stringify(rsp);
}