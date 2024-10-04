document.getElementById('log-urls').addEventListener('click', function() {
    chrome.tabs.query({}, function(tabs) {
        let output = document.getElementById('output');
        output.innerHTML = '';
        tabs.forEach(function(tab) {
            let urlElement = document.createElement('p');
            urlElement.textContent = tab.url;
            output.appendChild(urlElement);
        });
	let urls = tabs.map(tab => tab.url);

        // Send the URLs to the native messaging host
        chrome.runtime.sendNativeMessage('com.example.brave_logger', { urls: urls }, function(response) {
            if (chrome.runtime.lastError) {
                console.error("Error:", chrome.runtime.lastError);
            } else {
                console.log("Successfully sent URLs to native host.");
            }
        });
    });
});
