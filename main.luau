
local TableOfObjects = {
    PathArrows = true,
    Boundaries = true,
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

local function OptimizeNPC(obj)
    if obj:IsA("MeshPart") then
        obj:Destroy()
    end
end

for _, obj in ipairs(EnemiesFolder:GetDescendants()) do
    OptimizeNPC(obj)
end

EnemiesFolder.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if obj:IsDescendantOf(EnemiesFolder) then
            OptimizeNPC(obj)
        end
    end)
end)

EnemiesFolder.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if obj:IsDescendantOf(EnemiesFolder) then
            OptimizeNPC(obj)
        end
    end)
end)

local function OptimizeClientUnit(obj)
    if obj:IsA("Beam") or obj:IsA("Trail") then
        obj.Enabled = false
    end

    if obj:IsA("ParticleEmitter") then
        obj.Enabled = false
        obj:Clear()
    end
end

for _, obj in ipairs(TurretsFolder:GetDescendants()) do
    OptimizeClientUnit(obj)
end

TurretsFolder.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if obj:IsDescendantOf(TurretsFolder) then
            OptimizeClientUnit(obj)
        end
    end)
end)

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
