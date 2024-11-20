window.addEventListener('offline', () => {
  let msg = '==> You are now offline.';
  alert(msg);
  console.log(msg);
});

window.addEventListener('online', () => {
  let msg = '==> You are now online.';
  alert(msg);
  console.log(msg);
});
