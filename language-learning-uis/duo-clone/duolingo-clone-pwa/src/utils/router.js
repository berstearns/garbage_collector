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
