module.exports = async function(el){
   await test();
   el.text = '执行完毕,看控制台输出';
};
function takeLongTime() {
    return new Promise(resolve => {
        setTimeout(() => resolve("long_time_value"), 1000);
    });
}

async function test() {
    const v = await takeLongTime();
    console.log(v);
}