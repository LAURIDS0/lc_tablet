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
    const now = new Date();
    const hours = now.getHours();
    const minutes = now.getMinutes();
    const seconds = now.getSeconds();
    const timeStr = `${hours.toString().padStart(2,'0')}:${minutes.toString().padStart(2,'0')}:${seconds.toString().padStart(2,'0')}`;
    const timeEl = document.getElementById('time');
    if (timeEl) timeEl.textContent = timeStr;

    // Date formatting: e.g. Tue 14 Oct or localized short form
    const dateEl = document.getElementById('date');
    if (dateEl) {
        const opts = { weekday: 'short', day: 'numeric', month: 'short' };
        dateEl.textContent = now.toLocaleDateString(undefined, opts);
    }
}

// Setup battery level display; tries to use the Battery Status API when available, otherwise falls back to a demo/random value
function initBatteryIndicator() {
    const batteryEl = document.getElementById('batteryLevel');
    if (!batteryEl) return;

    function applyBatteryLevel(percent, charging = false) {
        // percent: 0..100
        const level = Math.max(0, Math.min(100, Math.round(percent))) / 100;
        batteryEl.style.setProperty('--level', level);
        // update only the percent text node (don't clobber the SVG)
        const textEl = batteryEl.querySelector('.batteryText');
        if (textEl) textEl.textContent = `${Math.round(percent)}%`;
        if (percent <= 18) {
            batteryEl.setAttribute('data-low', 'true');
        } else {
            batteryEl.removeAttribute('data-low');
        }
        if (charging) {
            batteryEl.setAttribute('data-charging', 'true');
        } else {
            batteryEl.removeAttribute('data-charging');
        }
    }

    // Try the Battery Status API
    if (navigator.getBattery) {
        navigator.getBattery().then(function(batt) {
            function updateFromBattery() {
                const pct = batt.level * 100;
                applyBatteryLevel(pct, batt.charging);
            }
            updateFromBattery();
            batt.addEventListener('levelchange', updateFromBattery);
            batt.addEventListener('chargingchange', updateFromBattery);
        }).catch(function() {
            // fallback to demo
            applyBatteryLevel(Math.round(20 + Math.random() * 80));
        });
    } else {
        // No Battery API — use server / NUI message or demo value
        // If running in an environment where the host can message battery level, listen for a custom event 'setBatteryLevel'
        window.addEventListener('setBatteryLevel', function(e) {
            const pct = e.detail && typeof e.detail.level === 'number' ? e.detail.level : null;
            const charging = e.detail && typeof e.detail.charging === 'boolean' ? e.detail.charging : false;
            if (pct !== null) applyBatteryLevel(pct, charging);
        });

        // As a fallback, set a demo value. Remove or replace in production.
        applyBatteryLevel(Math.round(22 + Math.random() * 74));
    }
}

// Initialize on DOMContentLoaded
document.addEventListener('DOMContentLoaded', function() {
    updateTime();
    initBatteryIndicator();
    setInterval(updateTime, 1000);
});

// Close tablet on Escape key press
window.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        document.getElementById('tabletBox').style.display = 'none';
        fetch('https://lc_tablet/closeTablet', { method: 'POST' });
    }
});