RegisterNetEvent('lc_tablet:client:openSIM')
AddEventHandler('lc_tablet:client:openSIM', function()
    exports.ox_inventory:displayMetadata({tabletId = 'TabletID'})
    local items = exports.ox_inventory:Search('slots', 'lc_tablet')
    if items and #items > 0 then
        exports.ox_inventory:closeInventory()
        local tabletId = items[1].metadata.tabletId
        TriggerServerEvent('lc_tablet:server:openTabletStash', tabletId)
    else
        lib.notify({
            title = 'Tablet',
            status = 'error',
            description = 'You do not have a tablet in your inventory.'
        })
    end
end)

RegisterNetEvent('lc_tablet:client:openTabletStash')
AddEventHandler('lc_tablet:client:openTabletStash', function(stashId, owner)
    exports.ox_inventory:openInventory('stash', {id=stashId, owner=owner})
end)

local currentStashId = nil
RegisterNetEvent('lc_tablet:client:openTabletStash')
AddEventHandler('lc_tablet:client:openTabletStash', function(stashId, owner)
    currentStashId = stashId
    exports.ox_inventory:openInventory('stash', {id=stashId, owner=owner})
end)

-- Handle using the tablet item
RegisterNetEvent('lc_tablet:client:useTablet')
AddEventHandler('lc_tablet:client:useTablet', function()
    local items = exports.ox_inventory:Search('slots', 'lc_tablet')
    if items and #items > 0 then
        exports.ox_inventory:closeInventory()
        local tabletId = items[1].metadata.tabletId
        TriggerServerEvent('lc_tablet:server:requestUSBApps', tabletId)
    else
        lib.notify({
            title = 'Tablet',
            status = 'error',
            description = 'You do not have a tablet in your inventory.'
        })
        return
    end
end)

-- Handle receiving the available apps from the server and open the tablet UI
RegisterNetEvent('lc_tablet:client:receiveUSBApps')
AddEventHandler('lc_tablet:client:receiveUSBApps', function(availableApps)
    SetNuiFocus(true, true)
    local filteredApps = {}
    for _, app in ipairs(availableApps) do
        if app.data and app.data ~= 0 then
            table.insert(filteredApps, app)
        end
    end
    SendNUIMessage({ action = 'openTablet', apps = filteredApps })
    local playerPed = PlayerPedId()
    RequestAnimDict("amb@world_human_seat_wall_tablet@female@idle_a")
    while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@idle_a") do Wait(10) end
    TaskPlayAnim(playerPed, "amb@world_human_seat_wall_tablet@female@idle_a", "idle_a", 8.0, -8.0, -1, 49, 0, false, false, false)
    Wait(50)
    local tablet = CreateObject(GetHashKey("prop_cs_tablet"), table.unpack(GetEntityCoords(playerPed)), true, true, false)
    AttachEntityToEntity(tablet, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
end)

local function isInOpenInTablet(exportValue)
    for _, v in ipairs(Config.OpenInTablet) do
        if exportValue == v then
            return true
        end
    end
    return false
end

-- NUI callback for app usage, print export value
RegisterNUICallback('useApp', function(data, cb)
    cb({ export = data and data.app and data.app.export })
    if isInOpenInTablet(data.app.export) then
        local exportFunction = data and data.app and data.app.export
        if exportFunction then
            local func, err = load("return " .. exportFunction)
            if func then
                local success, result = pcall(func)
                if not success then
                    print('Error calling export function:', result)
                end
            else
                lib.notify({
                    title = 'Tablet',
                    status = 'error',
                    description = 'Failed to load export function: ' .. err
                })
            end
        end
    else
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'closeTablet' })
        local playerPed = PlayerPedId()
        ClearPedTasks(playerPed)
        for _, prop in ipairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(prop, playerPed) then
                DeleteEntity(prop)
            end
        end
        local exportFunction = data and data.app and data.app.export
        if exportFunction then
            local func, err = load("return " .. exportFunction)
            if func then
                local success, result = pcall(func)
                if not success then
                    print('Error calling export function:', result)
                end
            else
                lib.notify({
                    title = 'Tablet',
                    status = 'error',
                    description = 'Failed to load export function: ' .. err
                })
            end
        end
    end
end)

-- Listen for messages from the "Esc" key press to close the tablet
RegisterNUICallback('closeTablet', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeTablet' })
    cb('ok')
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed)
    for _, prop in ipairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(prop, playerPed) then
            DeleteEntity(prop)
        end
    end
end)


local function fallback_export()
    lib.notify({
        title = 'Tablet',
        status = 'error',
        description = 'Pointing to a fallback export, please check the app configuration, or contact support.'
    })
end
exports('fallback_export', fallback_export)