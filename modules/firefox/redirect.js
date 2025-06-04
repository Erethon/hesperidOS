chrome.webRequest.onBeforeRequest.addListener(
  function(details) {
    return {redirectUrl: details.url.replace("nixos.wiki", "wiki.nixos.org")};
  },
  {urls: ["*://nixos.wiki/*"]},
  ["blocking"]
);
