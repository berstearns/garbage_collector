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
        messageElement.textContent = `${message.sender}: ${message.text}`;
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
