RegisterNetEvent('lc_tablet:client:openSIM')
AddEventHandler('lc_tablet:client:openSIM', function()
    exports.ox_inventory:displayMetadata({ tabletId = 'TabletID'})
    print(json.encode({ tabletId = 'TabletID' }, { indent = true }))
end)


RegisterNetEvent('lc_tablet:client:useTablet')
AddEventHandler('lc_tablet:client:useTablet', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openTablet' })
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@idle_a")
    while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@idle_a") do
        Wait(10)
    end
    local playerPed = PlayerPedId()
    TaskPlayAnim(playerPed, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_a", 8.0, -8.0, -1, 49, 0, false, false, false)
end)

RegisterNUICallback('closeTablet', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeTablet' })
    cb('ok')
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
end)