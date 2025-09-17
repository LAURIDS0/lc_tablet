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
        id = "police",
        name = "Police",
        icon = "images/police.png",
        item = "lc_police_usb",
        export = "exports['lc_usb_police']:openPoliceApp()"
    },


    -- New Apps Below
    { -- Changes needed here
        id = "training_hacking",
        name = "Training Hacking",
        icon = "images/training_hacking.png",
        item = "lc_hacking_usb",
        export = "exports['lc_ucb_hacking_training']:openTrainingHacking()"
    },
    {
        id = "ambulance",
        name = "Ambulance",
        icon = "images/ems.png",
        item = "lc_ambulance_usb",
        export = "lc_ambulance:client:openAmbulanceApp" -- Placeholder export
    },
    {
        id = "boosting",
        name = "Boosting",
        icon = "images/boosting.png",
        item = "lc_boosting_usb",
        export = "rahe-boosting:client:openTablet" -- Placeholder export
    },
    {
        id = "hacking",
        name = "Hacking",
        icon = "images/hacking.png",
        item = "lc_hacking_usb",
        export = "rahe-boosting:client:hackingDeviceUsed" -- Placeholder export
    },
}

Config.OpenInTablet = {
    "exports['cw-racingapp']:openRacingApp()",
    "exports['lc_usb_browser']:openBrowserApp()",
    "exports['lc_usb_police']:openPoliceApp()",
    -- Add as many exports here as needed
}