local healthCheckEnabled = true

SLASH_HEALTHCHECK1 = '/healthcheck'
SlashCmdList["HEALTHCHECK"] = function()
    healthCheckEnabled = not healthCheckEnabled -- Toggle the state
    if healthCheckEnabled then
        DEFAULT_CHAT_FRAME:AddMessage("Healthcheck enabled.", 1, 1, 1) -- Yellow color for activation message
    else
        DEFAULT_CHAT_FRAME:AddMessage("Healthcheck disabled.", 1, 1, 1) -- Yellow color for stop message
    end
end


local messages = {
    "Smile and be grateful that you can game with the boys :)",
    "Do 10 jumping jacks.",
    "Do 10 push-ups.",
    "Do 5 shoulder circles and stretch your legs.",
    "Take 10 deep breaths. Inhale through the nose, hold for a second, inhale briefly again, exhale through the mouth.",
    "Check your posture, stretch your back and neck.",
    "Walk 10 laps around your room.",
    "Hold a 30-second plank.",
    "Do 10 squats.",
    "Rotate your wrists and ankles for 30 seconds.",
    "Close your eyes and count to 60.",
    "Perform 10 lunges.",
    "Squeeze an imaginary stress ball for 1 minute.",
    "Stand and stretch arms overhead for 30 seconds."
}


local timeSinceLastUpdate = 0
local interval = 1200


local function GetRandomMessage()
    return messages[math.random(#messages)]
end


local function DisplayRaidWarningMessage()
    if healthCheckEnabled then
        RaidNotice_AddMessage(RaidWarningFrame, GetRandomMessage(), ChatTypeInfo["RAID_WARNING"])
        PlaySound(12889) -- Play the raid warning sound
    end
end


local HealthCheckEventFrame = CreateFrame("Frame")


HealthCheckEventFrame:SetScript("OnUpdate", function(self, elapsed)
    if not healthCheckEnabled then return end

    timeSinceLastUpdate = timeSinceLastUpdate + elapsed
    if timeSinceLastUpdate >= interval then
        DisplayRaidWarningMessage()
        timeSinceLastUpdate = 0
    end
end)


HealthCheckEventFrame:RegisterEvent("PLAYER_LOGIN")
HealthCheckEventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
        healthCheckEnabled = true
        timeSinceLastUpdate = 0
    end
end)