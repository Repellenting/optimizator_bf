local inv = getgenv().inv or {}
local config = {
    fps = inv.fps or 10,
    disable3d = (inv.disable3d ~= nil) and inv.disable3d or true,
    ultraOpt = (inv.ultraOpt ~= nil) and inv.ultraOpt or true,
    disableGui = (inv.disableGui ~= nil) and inv.disableGui or true,
    removeSounds = (inv.removeSounds ~= nil) and inv.removeSounds or true,
    anchor = (inv.anchor ~= nil) and inv.anchor or true
}
setfpscap(config.fps)
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
if config.disable3d then
    RunService:Set3dRenderingEnabled(false)
end
local function ultraOptimization()
    if not config.ultraOpt then return end
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostProcessEffect") or effect:IsA("Atmosphere") or effect:IsA("Clouds") or effect:IsA("Sky") then
            effect:Destroy()
        end
    end
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    if config.removeSounds then
        for _, sound in ipairs(game:GetDescendants()) do
            if sound:IsA("Sound") then
                sound:Stop()
                sound:Destroy()
            end
        end
    end
end
local function disableAllGui()
    if not config.disableGui then return end
    task.spawn(function()
        local success = false
        while not success do
            success = pcall(function()
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
            end)
            task.wait(0.5)
        end
    end)
    local playerGui = player:WaitForChild("PlayerGui")
    playerGui:ClearAllChildren()
    playerGui.ChildAdded:Connect(function(child)
        task.wait()
        child:Destroy()
    end)
end
local function killSpammingSystems(character)
    local playerScriptsNames = {"EffectsLocalThread", "WaterCFrame", "DetailsStreaming", "AnimateEntrance", "FortBuilderClient", "AmbientMusic"}
    local characterScriptsNames = {"Aura", "Soru", "Dodge", "Run", "Fling and Underwater Glitching Fix"}
    local replicatedNames = {"ObservationManager", "FortBuilder"}
    local pScripts = player:WaitForChild("PlayerScripts")
    for _, name in ipairs(playerScriptsNames) do
        local s = pScripts:FindFirstChild(name)
        if s then s:Destroy() end
    end
    for _, name in ipairs(characterScriptsNames) do
        local s = character:FindFirstChild(name)
        if s then s:Destroy() end
    end
    for _, name in ipairs(replicatedNames) do
        local folder = ReplicatedStorage:FindFirstChild("Util") or ReplicatedStorage
        local s = folder:FindFirstChild(name) or ReplicatedStorage:FindFirstChild(name)
        if s then s:Destroy() end
    end
end
local function onCharacterSpawned(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local objectsToDelete = {"_WorldOrigin", "BaristaCutsceneDummy_Stored", "FanArt", "Fruit ", "Game", "Leaderboards", "Model", "Beam", "Flower1", "Flower2", "Lab Battle", "Boats", "ChestModels", "Map", "NPCs", "Arenas", "ActiveFishingSpots", "CutParts", "Folder", "SeaBeasts", "SeaEvents", "SlappingMinigameFolder", "SpawnedItems", "GhostShip"}
    for _, objectName in ipairs(objectsToDelete) do
        local obj = workspace:FindFirstChild(objectName)
        if obj then obj:Destroy() end
    end
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("Part") or part:IsA("MeshPart") then
            part.Material = Enum.Material.SmoothPlastic
            part.Reflectance = 0
        elseif part:IsA("Decal") or part:IsA("Texture") or part:IsA("ParticleEmitter") or part:IsA("Trail") then
            part:Destroy()
        end
    end
    ultraOptimization()
    disableAllGui()
    killSpammingSystems(character)
    if config.anchor then
        humanoidRootPart.Anchored = true
    end
end
if player.Character then onCharacterSpawned(player.Character) end
player.CharacterAdded:Connect(onCharacterSpawned)

print("Script loaded with FPS:", config.fps)
