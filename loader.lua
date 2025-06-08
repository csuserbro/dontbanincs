local http = game:GetService("HttpService")
local link = "https://weareghost.glitch.me"
local script_name = "aks-loader"

local checked = false

local function SendNotif(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5
    })
end

local function CheckConnection()
    if checked == false then
        checked = true
        local body = game:HttpGetAsync(link.."/check-server-connection")
        if body then
            local result = http:JSONDecode(body)
            if result and result.status == "ok" then
                SendNotif("Server connection", "🟢 server connected")
            else
                SendNotif("Server connection", "🔴 connection failed")
            end
        end
    end
end

CheckConnection()

local result = game:HttpGetAsync(link.."/load/"..script_name)
local body = http:JSONDecode(result)
local timer = tick()

while wait() do
    if body then
        timer = nil
        loadstring(game:HttpGet(body.url))()
        break
    else
        if tick() - timer >= 5 then
            SendNotif("Error", "Failed to load script. Please try again")
            timer = nil
            break
        end
    end
end
