setTimeout(() => {
  document.addEventListener = () => {};
  window.addEventListener = () => {};
}, 0);

EventTarget.prototype._addEventListener = EventTarget.prototype.addEventListener;
EventTarget.prototype.addEventListener = function(type, listener, options) {
  if (type.includes('key')) {
    console.log('阻止键盘事件监听:', type);
    return;
  }
  this._addEventListener(type, listener, options);
};
