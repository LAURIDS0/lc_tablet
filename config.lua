Config = {}

Config.Apps = {
    { -- Done
        id = "maps",
        name = "Maps",
        icon = "images/maps.png",
        item = "lc_map_usb",
        export = "exports['lc_usb_map']:openMapApp()"
    },
    { -- Done
        id = "racing",
        name = "Racing",
        icon = "images/race.png",
        item = "lc_raceing_usb",
        export = "exports['cw-racingapp']:openRacingApp()"
    },
    { -- Changes needed here
        id = "browser",
        name = "Browser",
        icon = "images/browser.png",
        item = "lc_browser_usb",
        export = "exports['lc_usb_browser']:openBrowserApp()"
    },
    { -- Changes needed here
        id = "training_hacking",
        name = "Training Hacking",
        icon = "images/training_hacking.png",
        item = "lc_hacking_usb",
        export = "exports['lc_ucb_hacking_training']:openTrainingHacking()"
    },
    { -- Changes needed here
        id = "dispatch",
        name = "Dispatch",
        icon = "images/dispatch.png",
        item = "lc_police_usb",
        export = "exports['lc_usb_dispatch']:openDispatchApp()" -- Placeholder export
    },
    { -- Changes needed here
        id = "boosting",
        name = "Boosting",
        icon = "images/boosting.png",
        item = "lc_boosting_usb",
        export = "exports['lc_usb_boosting']:openBoostingApp()" -- Placeholder export
    },


    -- New Apps Below
    {
        id = "police",
        name = "Police",
        icon = "images/police.png",
        item = "lc_police_usb",
        export = "exports['lc_tablet']:fallback_export()" -- Placeholder export
    },
    {
        id = "ambulance",
        name = "Ambulance",
        icon = "images/ems.png",
        item = "lc_ambulance_usb",
        export = "exports['lc_tablet']:fallback_export()" -- Placeholder export
    },
    {
        id = "hacking",
        name = "Hacking",
        icon = "images/hacking.png",
        item = "lc_hacking_usb",
        export = "exports['lc_tablet']:fallback_export()" -- Placeholder export
    },
}

Config.OpenInTablet = {
    "exports['cw-racingapp']:openRacingApp()",
    "exports['lc_usb_browser']:openBrowserApp()",
    "exports['lc_usb_dispatch']:openDispatchApp()",
    "exports['lc_usb_boosting']:openBoostingApp()",
    -- Add as many exports here as needed
}