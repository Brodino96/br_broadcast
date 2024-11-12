----------------- # ----------------- # ----------------- # -----------------

local broadcasters = {}

----------------- # ----------------- # ----------------- # -----------------

function IsStaff(id)
    return true
    --return IsPlayerAceAllowed(id, "admin")
end

----------------- # ----------------- # ----------------- # -----------------

RegisterCommand("broadcast", function (source)
    if not IsStaff(source) then
        return
    end

    if broadcasters[source] then
        print("removing")
        TriggerClientEvent("br_broadcast:removeBroadcaster", -1, source)
        broadcasters[source] = nil
        return
    end

    TriggerClientEvent("br_broadcast:initBroadcast", source)
end, false)

----------------- # ----------------- # ----------------- # -----------------

RegisterNetEvent("br_broadcast:addBroadcaster")
AddEventHandler("br_broadcast:addBroadcaster", function ()
    broadcasters[source] = true
    TriggerClientEvent("br_broadcast:addBroadcaster", -1, source)
end)

----------------- # ----------------- # ----------------- # -----------------