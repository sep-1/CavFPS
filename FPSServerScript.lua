local lookevent = game:GetService("ReplicatedStorage").LookEvent
local weaponsetup = game:GetService("ReplicatedStorage").WeaponSetup
local neckC0 = CFrame.new(0, 0.8, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local waistC0 = CFrame.new(0, 0.2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local rShoulderC0 = CFrame.new(1, 0.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local lShoulderC0 = CFrame.new(-1, 0.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
local ammostorage = game:GetService("ServerStorage"):WaitForChild("AmmoData")
pcall(function()
	lookevent.OnServerEvent:Connect(function(player, theta)
		local tPart = player.Character:FindFirstChild("tiltPart");
		if (tPart) then
			tPart.BodyPosition.Position = Vector3.new(theta, 0, 0);
		end
	end)
end)

weaponsetup.OnServerEvent:Connect(function(player, weapon)
	local serverweapon = weapon:Clone()
	local joint = Instance.new("Motor6D")
	joint.Part0 = player.Character.RightHand
	joint.Part1 = serverweapon.Handle
	joint.C0 = CFrame.Angles(0,math.pi,0)
	joint.Parent = serverweapon.Handle
	serverweapon.Parent = player.Character
	serverweapon.Name = "ServerWeapon"
	print(serverweapon.Parent)
	local tiltPart = Instance.new("Part");
	tiltPart.Size = Vector3.new(.1, .1, .1);
	tiltPart.Transparency = 1;
	tiltPart.CanCollide = false;
	tiltPart.Name = "tiltPart";
	tiltPart.Parent = player.Character;
	
	local bodyPos = Instance.new("BodyPosition");
	bodyPos.Parent = tiltPart;
	
	local neck = player.Character.Head.Neck;
	local waist = player.Character.UpperTorso.Waist;
	local rShoulder = player.Character.RightUpperArm.RightShoulder;
	local lShoulder = player.Character.LeftUpperArm.LeftShoulder;
	
	game:GetService("RunService").Heartbeat:Connect(function(dt)
		local theta = tiltPart.Position.x;
		neck.C0 = neckC0 * CFrame.fromEulerAnglesYXZ(theta*0.5, 0, 0);
		waist.C0 = waistC0 * CFrame.fromEulerAnglesYXZ(theta*0.5, 0, 0);
		rShoulder.C0 = rShoulderC0 * CFrame.fromEulerAnglesYXZ(theta*0.5, 0, 0);
		lShoulder.C0 = lShoulderC0 * CFrame.fromEulerAnglesYXZ(theta*0.5, 0, 0);
	end)
end)
