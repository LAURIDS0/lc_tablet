// document.getElementById('tabletBox').style.display = 'none'; // Initially hide the tablet

window.addEventListener('message', function(event) {
    if (event.data.action === 'openTablet') {
        document.getElementById('tabletBox').style.display = 'flex';
        updateTime(); // ensure time is correct immediately when opened
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

window.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.getElementById('tabletBox').style.display = 'none';
        fetch('https://lc_tablet/closeTablet', { method: 'POST' });
    }
});
