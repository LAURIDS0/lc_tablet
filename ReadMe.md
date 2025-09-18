# LC Tablet (FiveM)

A simple tablet/USB tray resource for FiveM that integrates with ox_inventory, oxmysql and optional ox_lib. Players can store USB "apps" in a tablet stash and open apps from a tablet UI.

## Features

- Tablet UI that shows installed USB apps from a per-tablet stash
- Uses ox_inventory stash system to store USB items per tablet
- Dynamically discovers apps defined in `config.lua`
- Supports running exports when apps are opened (can open inside the tablet UI or trigger an external export)

## Requirements

- FiveM (server)
- ox_inventory (inventory & stash)
- oxmysql (MySQL library)
- ox_lib (optional, used for some UI helpers/notifications)

Make sure the following resources are installed and started on your server:
- ox_inventory
- oxmysql
- ox_lib (optional)

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

{
    id = "maps",
    name = "Maps",
    icon = "images/maps.png",
    item = "lc_map_usb",
    export = "exports['lc_usb_map']:openMapApp()"
}

NOTE: The resource does not come bundled with the actual USB app resources (the exports). You must provide each app's resource or change the `export` strings to match the exports on your server.

## Required inventory items

Create inventory items matching the `item` fields in `Config.Apps`. For example (ox_inventory item JSON snippet):

- lc_map_usb
- lc_raceing_usb
- lc_browser_usb
- lc_police_usb
- lc_hacking_usb
- lc_ambulance_usb
- lc_boosting_usb

Adjust the list in `config.lua` to match your item names.

## How it works / Usage

- Players must have a tablet item in their inventory (an item named `lc_tablet` should exist in your inventory definitions).
- When the tablet is used, the client asks the server for apps installed in that tablet's stash. The stash id is generated as `tablet_stash_<tabletId>` where `<tabletId>` is read from the tablet item metadata.
- The server checks each configured app against the stash contents. If a matching USB item exists, the app is shown in the tablet UI.
- When the player opens an app, the resource either executes the export while keeping the tablet UI open (if listed in `Config.OpenInTablet`) or closes the tablet UI and then executes the export.

## Creating a USB app

To add a new app:
1. Add an entry to `Config.Apps` in `config.lua` with a unique `id`, `name`, `icon`, `item`, and `export`.
2. Ensure there is an inventory item with the same name as `item` and that you can place it in the tablet stash (or give it to the player for testing).
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

---

If you want the README to include code examples for creating ox_inventory items or sample exports, tell me which inventory system and item format you use and I will add examples.