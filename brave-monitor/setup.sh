#!/bin/bash

# Create the project directory
PROJECT_DIR="brave_tab_logger"
mkdir -p $PROJECT_DIR

# Navigate into the project directory
cd $PROJECT_DIR

# Create the manifest.json file
cat <<EOL > manifest.json
{
  "manifest_version": 2,
  "name": "Brave Tab URL Logger",
  "version": "1.0",
  "description": "Logs all open tab URLs in Brave.",
  "permissions": [
    "tabs"
  ],
  "background": {
    "scripts": ["background.js"],
    "persistent": false
  },
  "browser_action": {
    "default_popup": "popup.html",
    "default_icon": {
      "16": "icon.png",
      "48": "icon.png",
      "128": "icon.png"
    }
  },
  "icons": {
    "16": "icon.png",
    "48": "icon.png",
    "128": "icon.png"
  }
}
EOL

# Create the background.js file
cat <<EOL > background.js
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
EOL

# Create the popup.html file
cat <<EOL > popup.html
<!DOCTYPE html>
<html>
  <head>
    <title>Brave Tab Logger</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 10px;
      }
      button {
        padding: 5px 10px;
        font-size: 14px;
      }
    </style>
  </head>
  <body>
    <h1>Log Open Tab URLs</h1>
    <button id="log-urls">Log URLs</button>
    <div id="output"></div>
    <script src="popup.js"></script>
  </body>
</html>
EOL

# Create the popup.js file
cat <<EOL > popup.js
document.getElementById('log-urls').addEventListener('click', function() {
    chrome.tabs.query({}, function(tabs) {
        let output = document.getElementById('output');
        output.innerHTML = '';
        tabs.forEach(function(tab) {
            let urlElement = document.createElement('p');
            urlElement.textContent = tab.url;
            output.appendChild(urlElement);
        });
    });
});
EOL

# Create a simple icon.png (16x16 px), for demo purposes use a base64-encoded image
# You can replace it with your own icon if you want
cat <<EOL | base64 --decode > icon.png
iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAIAAAD1ECbUAAAAH0lEQVR42mP4/5/hPwMDAwNjY8KCgoJ8EoKCAQDiVxF0xOr29QAAAABJRU5ErkJggg==
EOL

# Print success message
echo "Project setup complete! The 'brave_tab_logger' folder has been created with all necessary files."
