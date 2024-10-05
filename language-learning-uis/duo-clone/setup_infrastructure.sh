#!/bin/bash

# Set up the project directory
PROJECT_DIR="duolingo-clone-pwa"

# Create the main project directory
mkdir -p $PROJECT_DIR

# Create the public directory and its subdirectories/files
mkdir -p $PROJECT_DIR/public/assets/images
mkdir -p $PROJECT_DIR/public/assets/icons

# index.html
cat <<EOL > $PROJECT_DIR/public/index.html
<!-- public/index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#4CAF50">
    <title>Duolingo Clone</title>
    <link rel="stylesheet" href="assets/styles.css">
    <link rel="manifest" href="manifest.json">
</head>
<body>
    <div id="app"></div>
    <script type="module" src="bundle.js"></script>
</body>
</html>
EOL

# manifest.json
cat <<EOL > $PROJECT_DIR/public/manifest.json
{
  "name": "Duolingo Clone",
  "short_name": "DuolingoClone",
  "start_url": "./index.html",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#4CAF50",
  "icons": [
    {
      "src": "assets/icons/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "assets/icons/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
EOL

# service-worker.js
cat <<EOL > $PROJECT_DIR/public/service-worker.js
self.addEventListener('install', event => {
    event.waitUntil(
        caches.open('v1').then(cache => {
            return cache.addAll([
                './',
                './index.html',
                './assets/styles.css',
                './manifest.json'
            ]);
        })
    );
});

self.addEventListener('fetch', event => {
    event.respondWith(
        caches.match(event.request).then(response => {
            return response || fetch(event.request);
        })
    );
});
EOL

# styles.css
cat <<EOL > $PROJECT_DIR/public/assets/styles.css
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    background-color: #f4f4f4;
}

#app {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    text-align: center;
}

button {
    padding: 10px 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    cursor: pointer;
}
EOL

# Create the src directory and its subdirectories/files
mkdir -p $PROJECT_DIR/src/components
mkdir -p $PROJECT_DIR/src/pages
mkdir -p $PROJECT_DIR/src/utils

# app.js
cat <<EOL > $PROJECT_DIR/src/app.js
import { router } from './utils/router.js';

document.addEventListener('DOMContentLoaded', () => {
    router();
});
EOL

# navbar.js
cat <<EOL > $PROJECT_DIR/src/components/navbar.js
export function navbar() {
    const nav = document.createElement('nav');
    nav.innerHTML = \`
        <ul>
            <li><a href="#/">Home</a></li>
            <li><a href="#/lessons">Lessons</a></li>
            <li><a href="#/profile">Profile</a></li>
        </ul>
    \`;
    return nav;
}
EOL

# lesson.js
cat <<EOL > $PROJECT_DIR/src/components/lesson.js
export function lesson(lessonTitle) {
    const lessonDiv = document.createElement('div');
    lessonDiv.className = 'lesson';
    lessonDiv.innerText = lessonTitle;
    return lessonDiv;
}
EOL

# profile.js
cat <<EOL > $PROJECT_DIR/src/components/profile.js
export function profile(userName) {
    const profileDiv = document.createElement('div');
    profileDiv.className = 'profile';
    profileDiv.innerText = \`User: \${userName}\`;
    return profileDiv;
}
EOL

# home.js
cat <<EOL > $PROJECT_DIR/src/pages/home.js
import { navbar } from '../components/navbar.js';

export function home() {
    const container = document.createElement('div');
    container.appendChild(navbar());
    container.innerHTML += '<h1>Welcome to Duolingo Clone</h1>';
    return container;
}
EOL

# lessons.js
cat <<EOL > $PROJECT_DIR/src/pages/lessons.js
import { navbar } from '../components/navbar.js';
import { lesson } from '../components/lesson.js';

export function lessons() {
    const container = document.createElement('div');
    container.appendChild(navbar());
    container.appendChild(lesson('Lesson 1'));
    container.appendChild(lesson('Lesson 2'));
    return container;
}
EOL

# profile.js
cat <<EOL > $PROJECT_DIR/src/pages/profile.js
import { navbar } from '../components/navbar.js';
import { profile } from '../components/profile.js';

export function profilePage() {
    const container = document.createElement('div');
    container.appendChild(navbar());
    container.appendChild(profile('John Doe'));
    return container;
}
EOL

# router.js
cat <<EOL > $PROJECT_DIR/src/utils/router.js
import { home } from '../pages/home.js';
import { lessons } from '../pages/lessons.js';
import { profilePage } from '../pages/profile.js';

export function router() {
    const app = document.getElementById('app');
    app.innerHTML = '';

    switch (window.location.hash) {
        case '#/lessons':
            app.appendChild(lessons());
            break;
        case '#/profile':
            app.appendChild(profilePage());
            break;
        default:
            app.appendChild(home());
            break;
    }
}

window.addEventListener('hashchange', router);
EOL

# storage.js
cat <<EOL > $PROJECT_DIR/src/utils/storage.js
export function saveData(key, value) {
    localStorage.setItem(key, JSON.stringify(value));
}

export function loadData(key) {
    return JSON.parse(localStorage.getItem(key));
}
EOL

# api.js
cat <<EOL > $PROJECT_DIR/src/utils/api.js
export function fetchData(endpoint) {
    return fetch(endpoint)
        .then(response => response.json())
        .catch(error => console.error('Error fetching data:', error));
}
EOL

# Create the build directory
mkdir -p $PROJECT_DIR/build

# Create a README file
cat <<EOL > $PROJECT_DIR/README.md
# Duolingo Clone PWA

This is a minimalistic Progressive Web App (PWA) that mimics the core features of Duolingo.

## Getting Started

1. Install a simple HTTP server if you don't have one:
   \`\`\`
   npm install -g http-server
   \`\`\`

2. Start the server:
   \`\`\`
   npx http-server ./public
   \`\`\`

3. Open your browser and navigate to \`http://localhost:8080\`.

## Project Structure

- **public/**: Contains static files like the HTML, CSS, and service worker.
- **src/**: Contains JavaScript source files, including components, pages, and utilities.
- **build/**: Will contain any build outputs if you choose to bundle your project.

## License

This project is licensed under the MIT License.
EOL

# Create package.json file
cat <<EOL > $PROJECT_DIR/package.json
{
  "name": "duolingo-clone-pwa",
  "version": "1.0.0",
  "description": "A minimalistic PWA clone of Duolingo.",
  "main": "src/app.js",
  "scripts": {
    "build": "rollup -c",
    "start": "npx http-server ./public"
  },
  "devDependencies": {
    "@rollup/plugin-commonjs": "^21.0.1",
    "@rollup/plugin-node-resolve": "^15.0.1",
    "@rollup/plugin-terser": "^0.4.0",
    "rollup": "^3.7.1"
  },
  "author": "",
  "license": "MIT"
}
EOL

cat <<EOL > $PROJECT_DIR/rollup.config.mjs
// rollup.config.js
import resolve from '@rollup/plugin-node-resolve';
import commonjs from '@rollup/plugin-commonjs';
import terser from '@rollup/plugin-terser'; 

export default {
  input: 'src/app.js',  // Entry point for your application
  output: {
    file: 'public/bundle.js',  // Output file
    format: 'iife',  // Immediately Invoked Function Expression, suitable for <script> tags
    name: 'App',  // Global variable name for your bundle
  },
  plugins: [
    resolve(),  // Allows Rollup to resolve modules from node_modules
    commonjs(),  // Converts CommonJS modules to ES6
    terser()  // Minifies the bundle for production
  ]
};
EOL


# Provide feedback
echo "Project structure for Duolingo Clone PWA has been set up in $PROJECT_DIR with minimal content."

