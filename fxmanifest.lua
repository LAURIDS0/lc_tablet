fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'LC Development'
description 'A tablet script for a full server controll.'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'oxmysql'
}

optional_dependencies {
    'ox_lib'
}

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js',
    'html/images/*.png'
}