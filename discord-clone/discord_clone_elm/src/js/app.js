// Initial state representation
let state = {
    server: {
        name: "Bernardo Stearns",
        categories: [
            {
                name: "General",
                channels: [
                    { name: "general-chat", messages: [] },
                    { name: "announcements", messages: [] }
                ]
            },
            {
                name: "Gaming",
                channels: [
                    { name: "game-chat", messages: [] },
                    { name: "game-updates", messages: [] }
                ]
            }
        ],
        selectedChannel: null
    }
};

// View: Rendering the entire application
function view() {
    const app = document.getElementById("app");
    app.innerHTML = ""; // Clear the app container

    // Render server
    const serverDiv = document.createElement("div");
    serverDiv.className = "server";

    const serverTitle = document.createElement("h2");
    serverTitle.textContent = state.server.name;
    serverDiv.appendChild(serverTitle);

    // Render categories
    state.server.categories.forEach((category) => {
        const categoryDiv = document.createElement("div");
        categoryDiv.className = "category";

        const categoryTitle = document.createElement("h3");
        categoryTitle.textContent = category.name;
        categoryDiv.appendChild(categoryTitle);

        // Render channels
        category.channels.forEach((channel) => {
            const channelDiv = document.createElement("div");
            channelDiv.className = "channel";
            channelDiv.textContent = "# " + channel.name;
            channelDiv.onclick = () => update({ type: "SELECT_CHANNEL", channel });

            categoryDiv.appendChild(channelDiv);
        });

        serverDiv.appendChild(categoryDiv);
    });

    app.appendChild(serverDiv);

    // Render messages if a channel is selected
    if (state.server.selectedChannel) {
        const messagesDiv = document.createElement("div");
        messagesDiv.className = "messages";

        state.server.selectedChannel.messages.forEach((message, index) => {
            const messageDiv = document.createElement("div");
            messageDiv.className = "message";
            messageDiv.textContent = message;
            messagesDiv.appendChild(messageDiv);
        });

        app.appendChild(messagesDiv);

        // Render input area
        const inputArea = document.createElement("div");
        inputArea.className = "input-area";

        const inputField = document.createElement("input");
        inputField.type = "text";
        inputField.placeholder = "Type a message...";
        inputField.id = "messageInput";

        const sendButton = document.createElement("button");
        sendButton.textContent = "Send";
        sendButton.onclick = () => {
            const message = document.getElementById("messageInput").value;
            update({ type: "SEND_MESSAGE", message });
        };

        inputArea.appendChild(inputField);
        inputArea.appendChild(sendButton);
        app.appendChild(inputArea);
    }
}

// Update: Handles actions and modifies state
function update(action) {
    switch (action.type) {
        case "SELECT_CHANNEL":
            state.server.selectedChannel = action.channel;
            break;
        case "SEND_MESSAGE":
            if (state.server.selectedChannel && action.message.trim() !== "") {
                state.server.selectedChannel.messages.push(action.message);
            }
            break;
        default:
            break;
    }
    view(); // Re-render the view with updated state
}

// Initial render
view();
