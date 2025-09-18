# LC Tablet (FiveM)

A simple tablet/USB tray resource for FiveM that integrates with ox_inventory, oxmysql and optional ox_lib. Players can store USB "apps" in a tablet stash and open apps from a tablet UI.

## Features

- Tablet UI that shows installed USB apps from a per-tablet stash
- Uses ox_inventory stash system to store USB items per tablet
- Dynamically discovers apps defined in `config.lua`
- Supports running exports when apps are opened (can open inside the tablet UI or trigger an external export)

## Requirements

- ox_inventory
- oxmysql
- ox_lib

## Installation

1. Drop the `lc_tablet` folder in your server `resources` folder.
2. Add the resource to your `server.cfg`:

   ensure lc_tablet

3. Restart the server or start the resource.

## Configuration

Open `config.lua` to configure apps and which exports should open inside the tablet UI.

- `Config.Apps` is a list of apps. Each app has:
  - `id` - unique id string
  - `name` - display name
  - `icon` - path to icon inside `html/images`
  - `item` - the inventory item name used as the USB in the stash
  - `export` - the Lua export or event to call when the app is used

- `Config.OpenInTablet` is a list of export strings. Any export listed here will be executed while the tablet UI remains open (useful for apps that run inside the UI). Other exports will close the tablet UI and then run.

Example app entry (already in `config.lua`):
```lua
    {
        id = "maps",
        name = "Maps",
        icon = "images/maps.png",
        item = "lc_map_usb",
        export = "exports['lc_usb_map']:openMapApp()"
    }
```
NOTE: The resource does not come bundled with the actual USB app resources (the exports). You must provide each app's resource or change the `export` strings to match the exports on your server.

## How to get the tablet.

The tablet need metadata to be able to work, use `ox_inventory/data/shops.lua` to setup the shop.
```lua
    ITStore = {
            name = 'IT-Store',
            blip = {
                id = 184, colour = 68, scale = 0.8
            }, inventory = {
                {
                    name = 'lc_tablet',
                    price = 0,
                    count = 1,
                    metadata = {
                        tabletId = math.random(111111, 999999),
                    }
                },
            }, locations = {
                vec3(342.99, -1298.26, 32.51)
            }, targets = {
                { loc = vec3(343.06, -1297.85, 31.51), length = 0.6, width = 3.0, heading = 65.0, minZ = 55.0, maxZ = 56.8, distance = 3.0 }
            }
        },
```

## How to open the tablet.

The tablet item is used in a very specific way, enter this in `ox_inventory/data/items.lua`to setup the item.
```lua
    ['lc_tablet'] = {
        label = 'Tablet',
        weight = 190,
        stack = false,
        consume = 0,
        client = {
            event = 'lc_tablet:client:useTablet',
        },
        buttons = {
            {
                label = 'Access USB',
                action = function()
                    TriggerEvent('lc_tablet:client:openSIM')
                end
            }
        },
    },
```

## How it works / Usage

- Players must have a tablet item in their inventory (an item named `lc_tablet` should exist in your inventory definitions).
- When the tablet is used, the client asks the server for apps installed in that tablet's stash. The stash id is generated as `tablet_stash_<tabletId>` where `<tabletId>` is read from the tablet item metadata.
- The server checks each configured app against the stash contents. If a matching USB item exists, the app is shown in the tablet UI.
- When the player opens an app, the resource either executes the export while keeping the tablet UI open (if listed in `Config.OpenInTablet`) or closes the tablet UI and then executes the export.

## Creating a USB app

To add a new app:
1. Add an entry to `Config.Apps` in `config.lua` with a unique `id`, `name`, `icon`, `item`, and `export`.
2. Ensure there is an inventory item with the same name as `item` and that you can place it in the tablet stash.
3. Provide the target export in another resource (for example `exports['my_app']:open()`) or change the `export` to an event you listen to.
4. Optionally add the export string to `Config.OpenInTablet` if the app should run inside the tablet UI.

## Example troubleshooting

- "Apps not showing": make sure the USB item exists inside the tablet stash (use ox_inventory stash debugging) and that `item` names match exactly.
- "Export not found": verify the resource that provides the export is installed and its export signature matches the string in `config.lua`.
- "oxmysql errors": ensure your MySQL credentials are correct and `oxmysql` is started before this resource.

## Contributing

Contributions and PRs are welcome. Keep changes focused and test thoroughly.

## License

MIT License