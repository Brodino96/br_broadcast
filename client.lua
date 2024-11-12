----------------- # ----------------- # ----------------- # -----------------

local broadcast = {
    active = false,
    speakers = {} -- {id, muted}
}
local live = false
local arr = {
    types = Config.veh.types,
    models = Config.veh.models,
    items = Config.items
}

----------------- # ----------------- # ----------------- # -----------------

local function removeBroadcaster(id)

    -- If you are the broadcaster leaving then reset range
    if id == GetPlayerServerId(PlayerId()) then
        return lib.notify({ type = "success", title = "Broadcast disattivato"})
    end

    -- Removes the entry from the array
    broadcast.speakers[id] = nil
    exports["pma-voice"]:removeBroadcaster(id)

    -- If there's still at least a speaker then stop
    for _, i in pairs(broadcast.speakers) do
        if i ~= nil then
            return
        end
    end

    -- If there's no speakers then deactivate the mod (stops the calculations)
    broadcast.active = false
end

local function addBroadcaster(id)

    if id == GetPlayerServerId(PlayerId()) then
        return lib.notify({ type = "success", title = "Broadcast attivato" })
    end

    exports["pma-voice"]:addBroadcaster(id)

    -- Adds the speaker to the array and mutes him
    broadcast.speakers[id] = { muted = true }
    exports["pma-voice"]:toggleMutePlayer(id)

    if broadcast.active then
        return
    end

    broadcast.active = true

    CreateThread(function ()
        while broadcast.active do

            Wait(1000) -- Every second

            local playerPed = PlayerPedId()

            for speaker, status in pairs(broadcast.speakers) do

                local canHear = false

                local veh

                -- If vehicle mode is active
                if not arr.types or not arr.models then
                    --print("no veh config")
                    goto items
                end

                -- Skips to items if player is not in any vehicle
                if not IsPedInAnyVehicle(playerPed, true) then
                    --print("non sei in un veicolo")
                    goto items
                end

                veh = GetVehiclePedIsIn(playerPed, false) or GetVehiclePedIsEntering(playerPed)

                if arr.types then
                    local vehType = GetVehicleType(veh)
                    --print(vehType)
                    for i = 1, #arr.types do
                        --print(arr.types[i])
                        if arr.types[i] == vehType then
                            canHear = true
                            --print("Sei in una macchina")
                            break
                        end
                    end
                end

                if canHear then
                    goto muter
                end

                if arr.models then
                    local vehModel = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                    for i = 1, #arr.models do
                        if arr.models[i] == vehModel then
                            canHear = true
                            --print("sei in una bati")
                            break
                        end
                    end
                end

                ::items::

                -- Item checks
                if not arr.items then
                    --print("No item config")
                    goto muter
                end

                for h = 1, #arr.items do
                    if exports["ox_inventory"]:GetItemCount(arr.items[h]) > 0 then
                        --print("hai una pistola")
                        canHear = true
                        break
                    end
                end

                ::muter::

                if canHear and status.muted then
                    exports["pma-voice"]:toggleMutePlayer(speaker)
                    broadcast.speakers[id].muted = false
                    --print("can listen")
                end

                if not canHear and not status.muted then
                    exports["pma-voice"]:toggleMutePlayer(speaker)
                    broadcast.speakers[id].muted = true
                    --print("muted")
                end

                print("Posso sentire? "..tostring(canHear))
                print("Lo speaker è mutato?"..tostring(broadcast.speakers[id].muted))
            end
        end
    end)

end

local function initBroadcast()
    local alert = lib.alertDialog({
        header = "ATTENZIONE",
        content = " Stai per attivare la modalità broadcast, una volta attivata potrai essere sentito da tutti i giocatori presenti nel server, sei sicuro di voler continuare?",
        centered = true,
        cancel = true,
        labels = {
            confirm = "Sono sicuro",
            cancel = "Annulla"
        }
    })

    if alert == "confirm" then
        TriggerServerEvent("br_broadcast:addBroadcaster")
    end
end

----------------- # ----------------- # ----------------- # -----------------

RegisterNetEvent("br_broadcast:addBroadcaster")
AddEventHandler("br_broadcast:addBroadcaster", addBroadcaster)

RegisterNetEvent("br_broadcast:removeBroadcaster")
AddEventHandler("br_broadcast:removeBroadcaster", removeBroadcaster)

RegisterNetEvent("br_broadcast:initBroadcast")
AddEventHandler("br_broadcast:initBroadcast", initBroadcast)

----------------- # ----------------- # ----------------- # -----------------