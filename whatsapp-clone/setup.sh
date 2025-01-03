#!/bin/bash

# Create project directory
mkdir -p whatsapp-clone

# Navigate into the project directory
cd whatsapp-clone

# Create necessary files
touch index.html styles.css script.js README.md

# Add basic content to index.html
cat <<EOL > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WhatsApp Clone</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="chat-container">
        <div id="sidebar">
            <h2>Chats</h2>
            <ul id="chat-list"></ul>
        </div>
        <div id="chat-window">
            <div id="chat-header">
                <h2 id="chat-title">Select a chat</h2>
            </div>
            <div id="chat-messages"></div>
            <div id="chat-input-container">
                <input type="text" id="chat-input" placeholder="Type a message..." disabled>
                <button id="send-button" disabled>Send</button>
            </div>
        </div>
    </div>
    <script src="script.js"></script>
</body>
</html>
EOL

# Add basic content to styles.css
cat <<EOL > styles.css
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    background-color: #f5f5f5;
}

#chat-container {
    display: flex;
    width: 80%;
    height: 80%;
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

#sidebar {
    width: 30%;
    border-right: 1px solid #ddd;
    padding: 10px;
}

#chat-window {
    flex: 1;
    display: flex;
    flex-direction: column;
}

#chat-header {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

#chat-messages {
    flex: 1;
    padding: 10px;
    overflow-y: auto;
}

#chat-input-container {
    display: flex;
    padding: 10px;
    border-top: 1px solid #ddd;
}

#chat-input {
    flex: 1;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

#send-button {
    margin-left: 10px;
    padding: 10px 20px;
    background-color: #007bff;
    color: #fff;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

#send-button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}
EOL

# Add basic content to script.js
cat <<EOL > script.js
// Hardcoded chat data
const chats = [
    {
        id: 1,
        name: "John Doe",
        messages: [
            { sender: "John Doe", text: "Hey, how are you?" },
            { sender: "You", text: "I'm good, thanks!" }
        ]
    },
    {
        id: 2,
        name: "Jane Smith",
        messages: [
            { sender: "Jane Smith", text: "Hi there!" },
            { sender: "You", text: "Hello!" }
        ]
    }
];

let selectedChat = null;

// DOM elements
const chatList = document.getElementById('chat-list');
const chatTitle = document.getElementById('chat-title');
const chatMessages = document.getElementById('chat-messages');
const chatInput = document.getElementById('chat-input');
const sendButton = document.getElementById('send-button');

// Render chat list
function renderChatList() {
    chatList.innerHTML = '';
    chats.forEach(chat => {
        const li = document.createElement('li');
        li.textContent = chat.name;
        li.addEventListener('click', () => selectChat(chat));
        chatList.appendChild(li);
    });
}

// Select a chat
function selectChat(chat) {
    selectedChat = chat;
    chatTitle.textContent = chat.name;
    renderMessages();
    chatInput.disabled = false;
    sendButton.disabled = false;
}

// Render messages
function renderMessages() {
    chatMessages.innerHTML = '';
    selectedChat.messages.forEach(message => {
        const messageElement = document.createElement('div');
        messageElement.textContent = \`\${message.sender}: \${message.text}\`;
        chatMessages.appendChild(messageElement);
    });
}

// Send message
sendButton.addEventListener('click', () => {
    const messageText = chatInput.value.trim();
    if (messageText) {
        selectedChat.messages.push({ sender: "You", text: messageText });
        renderMessages();
        chatInput.value = '';
    }
});

// Initialize
renderChatList();
EOL

# Add basic content to README.md
cat <<EOL > README.md
# WhatsApp Clone

This is a simple WhatsApp clone built using pure HTML, CSS, and JavaScript. The data is hardcoded in the JavaScript file.

## How to Run

1. Clone the repository.
2. Open \`index.html\` in your browser.

## Features

- View chat list
- Select a chat to view messages
- Send messages (hardcoded)

## License

This project is open-source and available under the MIT License.
EOL

# Make the script executable
chmod +x setup.sh

echo "Project setup complete. Navigate to the 'whatsapp-clone' directory and open 'index.html' in your browser."
