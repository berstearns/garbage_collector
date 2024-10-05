import { navbar } from '../components/navbar.js';

export function home() {
    const container = document.createElement('div');
    container.appendChild(navbar());
    container.innerHTML += '<h1>Welcome to Duolingo Clone</h1>';
    return container;
}
