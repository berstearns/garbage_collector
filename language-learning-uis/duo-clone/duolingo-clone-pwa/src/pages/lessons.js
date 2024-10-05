import { navbar } from '../components/navbar.js';
import { lesson } from '../components/lesson.js';

export function lessons() {
    const container = document.createElement('div');
    container.appendChild(navbar());
    container.appendChild(lesson('Lesson 1'));
    container.appendChild(lesson('Lesson 2'));
    return container;
}
