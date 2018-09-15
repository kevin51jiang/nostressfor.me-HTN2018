setInterval(updateGUI, 5000);

function updateGUI(){
    let currentURL = getCurrentURL();
    document.getElementById('currentURL').innerText = currentURL;
}