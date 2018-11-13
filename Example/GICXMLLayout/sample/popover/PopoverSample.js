var popover;
function showPopover(templateName) {
  popover = Popover.create(templateName);
  popover.present(true);
  popover.ondismiss = function (data) {
    document.getElementsByName('lblUserInfo')[0].text = `用户名：${data.userName},密码：${data.password}`;
  }
}

function closePopover(data) {
  popover.dismiss(true,data);
  popover = null;
}