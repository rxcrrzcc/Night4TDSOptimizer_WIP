
local TableOfObjects = {
    PathArrows = true,
    Boundaries = true,
    Cliff = true,
    Background = true,
    VFX = true,
    Lighting = true,
    Nametags = true,
    Sky = true,
    Tower = true,
}
local function DeleteSelectedObj(obj)
    if obj:IsA("Model")
    or obj:IsA("Folder")
    or obj:IsA("Sky") then
        obj:Destroy()
    end
end

task.spawn(function()
    for _, obj in ipairs(game:GetDescendants()) do
        if TableOfObjects[obj.Name] then
            DeleteSelectedObj(obj)
        end
    end
end)

game.DescendantAdded:Connect(function(obj)
    if TableOfObjects[obj.Name] then
        DeleteSelectedObj(obj)
    end
end)

local EnemiesFolder = workspace:WaitForChild("NPCs")
local TowersFolder = workspace:WaitForChild("Towers")
local TurretsFolder = workspace:WaitForChild("ClientUnits")

local function DisableAnimation(obj)
    if obj:IsA("Animation") then
        obj.AnimationId = ""
    end
end

local function WatchAnimations(folder)
    for _, obj in ipairs(folder:GetDescendants()) do
        DisableAnimation(obj)
    end

    folder.DescendantAdded:Connect(function(obj)
        DisableAnimation(obj)

        for _, descendant in ipairs(obj:GetDescendants()) do
            DisableAnimation(descendant)
        end
    end)
end

WatchAnimations(EnemiesFolder)
WatchAnimations(TowersFolder)
WatchAnimations(TurretsFolder)

local TrashFolder = workspace:WaitForChild("Trash")

for _, obj in ipairs(TrashFolder:GetChildren()) do
    obj:Destroy()
end

TrashFolder.ChildAdded:Connect(function(obj)
    obj:Destroy()
end)
print("N4 Optimizer successful loaded. By Zxll)
