export function navbar() {
    const nav = document.createElement('nav');
    nav.innerHTML = `
        <ul>
            <li><a href="#/">Home</a></li>
            <li><a href="#/lessons">Lessons</a></li>
            <li><a href="#/profile">Profile</a></li>
        </ul>
    `;
    return nav;
}
