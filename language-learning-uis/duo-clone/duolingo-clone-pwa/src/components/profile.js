export function profile(userName) {
    const profileDiv = document.createElement('div');
    profileDiv.className = 'profile';
    profileDiv.innerText = `User: ${userName}`;
    return profileDiv;
}
