var TestA = {
    showToast(msg) {
        var t = Toast.create('toast');
        t.show({ params: { text: msg }, position: 0, duration: 2000 });
    }
}
module.exports = TestA;