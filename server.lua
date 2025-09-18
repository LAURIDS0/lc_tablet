local registeredStashes = {}

RegisterNetEvent('lc_tablet:server:openTabletStash')
AddEventHandler('lc_tablet:server:openTabletStash', function(tabletId)
	local src = source
	local stashId = 'tablet_stash_' .. tabletId
	local owner = ('char%s:license'):format(src) -- Adjust owner logic as needed
	if not registeredStashes[stashId] then
		exports.ox_inventory:RegisterStash(stashId, 'Tablet USB Tray: '..tabletId, 10, 0, owner)
		registeredStashes[stashId] = true
	end
	TriggerClientEvent('lc_tablet:client:openTabletStash', src, stashId, owner)
end)

RegisterNetEvent('lc_tablet:server:requestUSBApps')
AddEventHandler('lc_tablet:server:requestUSBApps', function(tabletId)
    local src = source
    local stashId = 'tablet_stash_' .. tabletId
    local availableApps = {}
    for i, app in ipairs(Config.Apps) do
        local itemName = app.item
        local item = exports.ox_inventory:GetItem(stashId, itemName, nil, true)
        if item then
            local appData = {
                id = app.id,
                name = app.name,
                icon = app.icon,
                item = app.item,
                export = app.export,
                data = item
            }
            table.insert(availableApps, appData)
        end
    end
    TriggerClientEvent('lc_tablet:client:receiveUSBApps', src, availableApps)
end)