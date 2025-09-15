// // Hardcoded app config for website preview
// const hardcodedApps = [
//     {
//         id: "maps",
//         name: "Maps",
//         icon: "images/maps.png",
//         item: "lc_map_usb",
//         export: "lc_map:client:openMapApp"
//     },
//     {
//         id: "racing",
//         name: "Racing",
//         icon: "images/race.png",
//         item: "lc_raceing_usb",
//         export: "lc_raceing:client:openRaceApp"
//     },
//     {
//         id: "browser",
//         name: "Browser",
//         icon: "images/browser.png",
//         item: "lc_browser_usb",
//         export: "lc_browser:client:openBrowserApp"
//     }
// ];
// // Function to render apps from a given array
// function renderApps(apps) {
//     const appGrid = document.getElementById('appGrid');
//     appGrid.innerHTML = '';
//     if (apps && Array.isArray(apps)) {
//         apps.forEach((app, idx) => {
//             const div = document.createElement('div');
//             div.className = 'appIcon';
//             div.id = 'app_' + app.id;
//             div.innerHTML = `<img src='${app.icon}' style='height:60px;width:60px;'><br>${app.name}`;
//             div.onclick = function() {
//                 alert(`App clicked: ${app.name}`); // For website preview
//             };
//             appGrid.appendChild(div);
//         });
//     }
// }
// // If running as a website, show the tablet and render hardcoded apps
// if (window.location.protocol === 'file:' || window.location.hostname !== 'nui') {
//     document.getElementById('tabletBox').style.display = 'flex';
//     renderApps(hardcodedApps);
// }

document.getElementById('tabletBox').style.display = 'none'; // Initially hide the tablet


// Listen for messages from the Lua script to open the tablet
window.addEventListener('message', function(event) {
    if (event.data.action === 'openTablet') {
        document.getElementById('tabletBox').style.display = 'flex';
        updateTime();
        // Dynamisk generer apps
        appGrid.innerHTML = '';
        if (event.data.apps && Array.isArray(event.data.apps)) {
            event.data.apps.forEach((app, idx) => {
                const div = document.createElement('div');
                div.className = 'appIcon';
                div.id = 'app_' + app.id;
                div.innerHTML = `<img src='${app.icon}' style='height:60px;width:60px;'><br>${app.name}`;
                div.onclick = function() {
                    fetch('https://lc_tablet/useApp', {
                        method: 'POST',
                        body: JSON.stringify({ app: app })
                    });
                };
                appGrid.appendChild(div);
            });
        }
    }
    if (event.data.action === 'closeTablet') {
        document.getElementById('tabletBox').style.display = 'none';
    }
});

// Live clock: updates #time every second
function updateTime() {
    const timeEl = document.getElementById('time');
    if (!timeEl) return;
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');
    timeEl.textContent = `${hours}:${minutes}:${seconds}`;
}
// start the interval so the clock runs while the page is loaded
updateTime();
setInterval(updateTime, 1000);

// Set battery level (for demo purposes, this is static)
document.getElementById('batteryLevel').textContent = Math.floor(Math.random() * 101) + '%';

// Close tablet on Escape key press
window.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.getElementById('tabletBox').style.display = 'none';
        fetch('https://lc_tablet/closeTablet', { method: 'POST' });
    }
});
