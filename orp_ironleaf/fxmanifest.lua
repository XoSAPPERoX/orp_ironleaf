fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Sapper'
description 'Ironleaf nicotine pouch system'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory'
}