local camera = game.Workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
repeat wait() until player.Character
local char = player.Character
local humanoid = char:WaitForChild("Humanoid")
local viewmodel = game.ReplicatedStorage:WaitForChild("HandModel2"):Clone()
local repWeapon = game.ReplicatedStorage:WaitForChild("Gun by wolf")
local weapon = repWeapon:Clone()
local lookevent = game:GetService("ReplicatedStorage").LookEvent
local weaponsetup = game:GetService("ReplicatedStorage").WeaponSetup
weaponsetup:FireServer(repWeapon)
local defaultFOV = camera.FieldOfView
local ADStweeninfo = TweenInfo.new(0.666,Enum.EasingStyle.Quint)
local adstweendata = {["FieldOfView"] = 45}
local adscamtween = game:GetService("TweenService"):Create(camera,ADStweeninfo,adstweendata)
adstweendata["FieldOfView"] = defaultFOV
local adscamtweenout = game:GetService("TweenService"):Create(camera,ADStweeninfo,adstweendata)
weapon.Parent = viewmodel
viewmodel.Parent = camera
 
local joint = Instance.new("Motor6D");
joint.C0 = CFrame.new(3,-1.5,-2.95) * CFrame.Angles(0,math.pi,0) -- old final value -2.85
joint.Part0 = viewmodel.Head
joint.Part1 = weapon.Handle
joint.Parent = viewmodel.Head


local aimCount = 0;
local offset = weapon.Handle.CFrame:inverse() * CFrame.Angles(math.rad(-2.25),math.pi,0) * weapon.Aim.CFrame

local function aimDownSights(aiming)
	local start = joint.C1
	local goal = aiming and (joint.C0 * offset) or CFrame.new()

    aimCount = aimCount + 1
	local current = aimCount
	if aiming then
		adscamtween:Play()
	elseif not aiming then
		adscamtweenout:Play()
	end
    for t = 0, 101, 10 do
	    if (current ~= aimCount) then break end
	    game:GetService("RunService").RenderStepped:Wait()
		joint.C1 = start:Lerp(goal, t/100)
    end
end
local function updateArm(key)
	local shoulder = viewmodel[key.."UpperArm"][key.."Shoulder"];
	local cf = weapon[key].CFrame * CFrame.Angles(3*math.pi/2, math.pi, 0) * CFrame.new(0, 0.85, 0);
	shoulder.C1 = cf:inverse() * shoulder.Part0.CFrame * shoulder.C0;
end


--toggle aim down sights when right click is pressed down 
UIS.InputBegan:Connect(function(inputtype,gameprocessedevent)
	if inputtype.UserInputType == Enum.UserInputType.MouseButton2 then
		aimDownSights(true)
	end
end)
-- end aim down sights when right click is released
UIS.InputEnded:Connect(function(inputtype, gameprocessedevent)
	if inputtype.UserInputType == Enum.UserInputType.MouseButton2 then
		aimDownSights(false)
	end
end)
-- player death cleanup 
humanoid.Died:Connect(function()
    viewmodel.Parent = nil
end)

-- updates the viewmodel to game's runtime 
game:GetService("RunService").RenderStepped:Connect(function()
	viewmodel.Head.CFrame = camera.CFrame
	updateArm("Right")
end)
while true do 
	wait(0.1)
	lookevent:FireServer(math.asin(camera.CFrame.LookVector.y))
end
