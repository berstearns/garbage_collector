export function lesson(lessonTitle) {
    const lessonDiv = document.createElement('div');
    lessonDiv.className = 'lesson';
    lessonDiv.innerText = lessonTitle;
    return lessonDiv;
}
