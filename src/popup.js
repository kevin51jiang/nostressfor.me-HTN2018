setInterval(updateGUI, 500);

function updateGUI(){
    let currentURL = getCurrentURL();
    document.getElementById('currentURL').innerText = currentURL;
}