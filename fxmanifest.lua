fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Brodino"
description "Broadcast a player voice to all the players in the server that respect the config"
version "0.1"

shared_scripts { "@ox_lib/init.lua", "config.lua", }
server_scripts { "server.lua", }
client_scripts { "client.lua", }

dependencies {
    "pma-voice"
}