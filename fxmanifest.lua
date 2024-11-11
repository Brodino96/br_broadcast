fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Brodino"
description "Broadcast a player voice to all the players in the server that respect the config"
version "0.1"

shared_scripts { "config.lua", }
server_scripts { "server/*", }
client_scripts { "client/*", }

dependencies {
    "pma-voice"
}