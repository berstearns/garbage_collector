#!/bin/bash

# Define the project name
PROJECT_NAME="language_learning_analyzer_extension"

# Create the main project directory
mkdir -p "$PROJECT_NAME"

# Navigate to the project directory
cd "$PROJECT_NAME" || exit

# Create the manifest.json file
cat <<EOL > manifest.json
{
  "manifest_version": 3,
  "name": "Language Learning Analyzer",
  "version": "1.0",
  "description": "Analyze the text on a page for language learning",
  "permissions": ["activeTab", "scripting"],
  "host_permissions": ["<all_urls>"],
  "action": {
    "default_popup": "popup.html"
  },
  "background": {
    "service_worker": "background.js"
  },
  "content_scripts": [
    {
      "matches": ["<all_urls>"],
      "js": ["content.js"]
    }
  ]
}
EOL

# Create content.js
cat <<'EOL' > content.js
// Extract all visible text from the page
function extractText() {
  const elements = document.body.getElementsByTagName('*');
  let textContent = '';
  
  // Iterate over all elements and get visible text
  for (let element of elements) {
    const style = window.getComputedStyle(element);
    if (style.display !== 'none' && style.visibility !== 'hidden') {
      textContent += ' ' + element.innerText.trim();
    }
  }
  return textContent;
}

// Analyze the extracted text
function analyzeText(text) {
  const wordCount = text.split(/\s+/).length;
  const uniqueWords = new Set(text.toLowerCase().match(/\b(\w+)\b/g));
  return {
    totalWords: wordCount,
    uniqueWords: uniqueWords.size,
    uniqueWordList: Array.from(uniqueWords)
  };
}

// Run the extraction and analysis
const pageText = extractText();
const analysisResult = analyzeText(pageText);

// Send analysis result back to the popup or background script
chrome.runtime.sendMessage({ analysis: analysisResult });
EOL

# Create popup.html
cat <<'EOL' > popup.html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; width: 300px; padding: 10px; }
  </style>
</head>
<body>
  <h2>Page Analysis</h2>
  <div id="output"></div>
  <script src="popup.js"></script>
</body>
</html>
EOL

# Create popup.js
cat <<'EOL' > popup.js
// Listen for messages from content.js
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.analysis) {
    const output = document.getElementById('output');
    const { totalWords, uniqueWords, uniqueWordList } = request.analysis;
    
    output.innerHTML = `
      <p>Total Words: ${totalWords}</p>
      <p>Unique Words: ${uniqueWords}</p>
      <p>Unique Word List: ${uniqueWordList.join(', ')}</p>
    `;
  }
});
EOL

# Create an empty background.js (currently not used, but placeholder for potential future features)
touch background.js

echo "Chrome extension project structure created successfully in '$PROJECT_NAME' directory."
