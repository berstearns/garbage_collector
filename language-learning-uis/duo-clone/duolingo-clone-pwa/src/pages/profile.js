import { navbar } from '../components/navbar.js';
import { profile } from '../components/profile.js';

export function profilePage() {
    const container = document.createElement('div');
    container.appendChild(navbar());
    container.appendChild(profile('John Doe'));
    return container;
}
