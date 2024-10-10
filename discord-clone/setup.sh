#!/bin/bash

# Step 1: Set up project directory
PROJECT_NAME="discord_clone_elm"
echo "Creating project directory..."
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Step 2: Set up project structure
echo "Setting up project structure..."
mkdir -p src/{js,css}

# Step 3: Create HTML file
cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Discord Frontend Clone</title>
    <link rel="stylesheet" href="src/css/style.css">
</head>
<body>
    <div id="app"></div>
    <script src="src/js/app.js"></script>
</body>
</html>
EOF

# Step 4: Create CSS file
cat <<EOF > src/css/style.css
body {
    font-family: Arial, sans-serif;
    margin: 20px;
    background-color: #2f3136;
    color: #ffffff;
}

.server {
    border: 1px solid #40444b;
    padding: 10px;
    margin-bottom: 20px;
    background-color: #36393f;
}

.category {
    margin: 10px 0;
    border: 1px dashed #555;
    padding: 10px;
}

.channel {
    padding-left: 20px;
    cursor: pointer;
}

.channel:hover {
    color: #7289da;
}

.messages {
    margin-top: 20px;
    border-top: 1px solid #40444b;
    padding-top: 10px;
}

.message {
    margin-bottom: 10px;
}

.input-area {
    margin-top: 20px;
}
EOF

# Step 5: Create JavaScript file
cat <<EOF > src/js/app.js
// Initial state representation
let state = {
    server: {
        name: "My Server",
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
EOF

# Step 6: Finish script
echo "Setup complete. Open index.html in your browser to view the app."

