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
    local chairHash = GetHashKey("prop_chair_01a")
    local laptopHash = GetHashKey("prop_laptop_01a")

    -- Find nearest chair
    local coords = GetEntityCoords(playerPed)
    local chair = nil
    for _, obj in ipairs(GetGamePool('CObject')) do
        if GetEntityModel(obj) == chairHash then
            local objCoords = GetEntityCoords(obj)
            if #(coords - objCoords) < 2.0 then
                chair = obj
                break
            end
        end
    end

    -- Sit player on chair if found
    if chair then
        TaskStartScenarioAtPosition(playerPed, "PROP_HUMAN_SEAT_CHAIR", GetEntityCoords(chair), GetEntityHeading(chair), 0, true, false)
    else
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_SEAT_CHAIR", 0, true)
    end

    -- Create and attach laptop prop
    Wait(1000)
    local laptop = CreateObject(laptopHash, coords.x, coords.y, coords.z, true, true, false)
    AttachEntityToEntity(laptop, playerPed, GetPedBoneIndex(playerPed, 28422), 0.18, 0.02, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
end)

RegisterNUICallback('closeTablet', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeTablet' })
    cb('ok')
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
end)