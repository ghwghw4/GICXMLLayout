var popover;
function showPopover(templateName,element) {
  popover = Popover.create(templateName,element);
  popover.present(true);
}

function closePopover() {
  popover.dismiss(true);
  popover = null;
}