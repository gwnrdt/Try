assert(hookmetamethod, "Executor doesn't support hookmetamethod")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local config = getgenv().config
local discord = getgenv().discord

local queue_tp = queue_on_teleport or queueteleport or function() end
local getasset = getcustomasset or getsynasset or function(x) return x end

--------------------------------------------------
-- ANALYTICS BLOCK
--------------------------------------------------

for _,v in pairs(getgc(true)) do
    if typeof(v) == "function" and debug.info(v,"s"):find("AnalyticsPipelineController") then
        hookfunction(v,function()
            return task.wait(9e9)
        end)
    end
end

--------------------------------------------------
-- DISCORD PROTECTION
--------------------------------------------------

if discord ~= "https://discord.gg/xb2uk8yyD3" then
    LocalPlayer:Kick("Don't remove watermark.")
end

--------------------------------------------------
-- WAIT CHARACTER
--------------------------------------------------

LocalPlayer.CharacterAdded:Wait()
task.wait(2)

--------------------------------------------------
-- LOAD MODULES
--------------------------------------------------

local Controllers = LocalPlayer.PlayerScripts:WaitForChild("Controllers")
local Modules = ReplicatedStorage:WaitForChild("Modules")

local CosmeticLibrary = require(Modules.CosmeticLibrary)
local ItemLibrary = require(Modules.ItemLibrary)
local DataController = require(Controllers.PlayerDataController)

--------------------------------------------------
-- UNLOCK EVERYTHING
--------------------------------------------------

CosmeticLibrary.OwnsCosmetic = function() return true end
CosmeticLibrary.OwnsCosmeticNormally = function() return true end
CosmeticLibrary.OwnsCosmeticUniversally = function() return true end
CosmeticLibrary.OwnsCosmeticForWeapon = function() return true end

--------------------------------------------------
-- SOUND SYSTEM
--------------------------------------------------

local function playSound(file,name)
    local s = Instance.new("Sound",workspace)
    s.SoundId = getasset("unlockall/"..file)
    s.Volume = 1
    s:Play()
end

--------------------------------------------------
-- REMOTE HOOK
--------------------------------------------------

local Remotes = ReplicatedStorage.Remotes
local UseItem = Remotes.Replication.Fighter.UseItem

local old
old = hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}

    if getnamecallmethod()=="FireServer" and self==UseItem then
        if config.shootsoundenabled then
            playSound(config.shootsoundfile,"shoot")
        end
    end

    return old(self,...)
end)

--------------------------------------------------
-- NOTIFICATION
--------------------------------------------------

StarterGui:SetCore("SendNotification",{
    Title="Injection",
    Text="Unlock All Loaded!"
})
