document.addEventListener(
  "keydown",
  function (e) {
    if (e.ctrlKey && e.altKey && e.key.toLowerCase() === "r") {
      e.preventDefault();
      e.stopImmediatePropagation();
      console.log("🚫 Ctrl+Alt+R was blocked");
    }
  },
  true,
);
