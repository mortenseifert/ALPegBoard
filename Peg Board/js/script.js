function Render(html) {
    if (HTMLContainer)
        document.getElementById('controlAddIn').innerHTML = '';
    HTMLContainer.insertAdjacentHTML('beforeend', html);
}