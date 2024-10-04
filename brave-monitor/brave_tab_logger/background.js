chrome.runtime.onInstalled.addListener(function() {
    console.log("Extension Installed.");
});

function logTabURLs() {
    chrome.tabs.query({}, function(tabs) {
        tabs.forEach(function(tab) {
            console.log(tab.url);
        });
    });
}

chrome.browserAction.onClicked.addListener(function() {
    logTabURLs();
});
