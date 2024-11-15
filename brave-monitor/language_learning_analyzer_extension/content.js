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

// Send analysis result to background script
chrome.runtime.sendMessage({ type: "ANALYSIS_RESULT", analysis: analysisResult });

