const decoder = new TextDecoder();

function base64ToUnicode(base64String) {
  const binaryString = atob(base64String);
  const bytes = Uint8Array.from(binaryString, (char) => char.charCodeAt(0));
  return decoder.decode(bytes);
}

function setContent(content) {
  [primary, secondary = "\u00A0"] = base64ToUnicode(content).split(" _ ");
  document.getElementById("primary").textContent = primary;
  document.getElementById("secondary").textContent = secondary;
}

document.addEventListener('keyup', event => {
  if ([' ', 'ArrowRight'].includes(event.key))
  {
    webui.call('next', '');
  }
  if (['ArrowLeft'].includes(event.key))
  {
    webui.call('prev', '')
  }
});
