let lastAnalysisResult = null;

// Listen for messages from content.js
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === "ANALYSIS_RESULT") {
    lastAnalysisResult = message.analysis; // Store the result
  }
});

// Listen for popup requests and send the last analysis result
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === "GET_ANALYSIS_RESULT") {
    sendResponse(lastAnalysisResult);
  }
});
