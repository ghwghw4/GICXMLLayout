

var JSEXtension = {
  showAlert: function (el) {
    var alertView = new AlertView();
    alertView.title = '标题';
    alertView.message = '内容';
    alertView.addButton('取消',function(){
      el.text = '你点击了取消';
    });
    alertView.addButton('确定',function(){
      el.text = '你点击了确定按钮';
    });
    alertView.show();
  },
  // localStorage 相关API
  setItem: function () {
    localStorage.setItem('key1',(new Date()).getTime());
    alert('保存成功,value='+localStorage.getItem('key1'));
  },
  getItem: function (el) {
    el.text = localStorage.getItem('key1');
  },
  removeItem:function () {
    localStorage.removeItem('key1');
    alert('删除成功');
  }
};