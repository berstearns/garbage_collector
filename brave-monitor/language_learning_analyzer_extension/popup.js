chrome.runtime.sendMessage({ type: "GET_ANALYSIS_RESULT" }, (response) => {
  if (response) {
    const output = document.getElementById('output');
    const { totalWords, uniqueWords, uniqueWordList } = response;
    
    output.innerHTML = `
      <p>Total Words: ${totalWords}</p>
      <p>Unique Words: ${uniqueWords}</p>
      <p>Unique Word List: ${uniqueWordList.join(', ')}</p>
    `;
  } else {
    document.getElementById('output').innerText = "No analysis data found.";
  }
});
