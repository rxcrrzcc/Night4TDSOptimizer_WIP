
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

local newAnim = "rbxassetid://73450022899138"

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
        task.defer(function()
            if obj:IsDescendantOf(game) then
                DeleteSelectedObj(obj)
            end
        end)
    end
end)

local EnemiesFolder = workspace:WaitForChild("NPCs")
local TowersFolder = workspace:WaitForChild("Towers")
local TurretsFolder = workspace:WaitForChild("ClientUnits")

local function DisableAnimation(obj)
    if obj:IsA("Animation") then
        if string.lower(obj.Name) ~= "idle" then
            obj.AnimationId = newAnim
        end
    end
end

local function WatchAnimations(folder)

    -- Уже существующие объекты
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

local function RemoveTrash(obj)
    task.defer(function()
        if obj.Parent == TrashFolder then
            obj:Destroy()
        end
    end)
end

for _, obj in ipairs(TrashFolder:GetChildren()) do
    RemoveTrash(obj)
end

TrashFolder.ChildAdded:Connect(RemoveTrash)
