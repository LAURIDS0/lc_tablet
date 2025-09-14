document.getElementById('tabletBox').style.display = 'none';

window.addEventListener('message', function(event) {
    if (event.data.action === 'openTablet') {
        document.getElementById('tabletBox').style.display = 'flex';
    }
    if (event.data.action === 'closeTablet') {
        document.getElementById('tabletBox').style.display = 'none';
    }
});

window.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.getElementById('tabletBox').style.display = 'none';
        fetch('https://lc_tablet/closeTablet', { method: 'POST' });
    }
});
