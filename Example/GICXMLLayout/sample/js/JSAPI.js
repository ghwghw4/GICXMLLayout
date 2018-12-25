var JSAPI = {
    showToast(t) {
        setTimeout(function () {
            var t = Toast.create('toast');
            t.show({ params: { text: 'hello world(2秒后自动隐藏)' }, position: 0, duration: 2000 });
        }, t);
    },
    beginTick(el) {
        var t = 3000;
        var interval = setInterval(function () {
            t -= 100;
            el.text = t / 1000.0;
            if (t <= 0) {
                clearInterval(interval);
                el.text = '点击开始倒计时';
            }
        }, 100)
    },
    requireJS() {
        const TestA = require('/js/RequrieTest.js');
        TestA.showToast('测试require函数，导入JS文件');
    },
    requireJson(el) {
        const data = require('/js/RequireJsonTest.json');
        el.text = 'app名称：' + data.appName + '\n版本号：' + data.version;
    }
};