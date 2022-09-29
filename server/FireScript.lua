local RS = game:GetService("ReplicatedStorage")
local fireevent = RS:WaitForChild("FireEvent")
local REvent = RS:WaitForChild("REvent")
local plrs = game:GetService("Players")
local SS = game:GetService("ServerStorage")
local debris = game:GetService("Debris")
_G.weapondata = { -- specs for different weapons
	["pistoldata"] = {["maxdmg"] = 65, ["maxbullets"] = 15},
	["shotgundata"] = {["maxdmg"] = 28, ["maxbullets"] = 8},
	["MGdata"] = {}
}
-- determines which side of a surface the bullet ray lands on
local function surfacepointer(pointonsurface, part)
	local rayobjectcf = part.CFrame:PointToObjectSpace(pointonsurface)
	local Xside = part.Size.X*.5 
	local Yside = part.Size.Y*.5
	local Zside = part.Size.Z*.5
	local pointingobjcf
	if rayobjectcf.X >= Xside or rayobjectcf.X <= -Xside then
		pointingobjcf = CFrame.new(rayobjectcf, Vector3.new(0, rayobjectcf.Y, rayobjectcf.Z))
	elseif rayobjectcf.Y >= Yside or rayobjectcf.Y <= -Yside then
		pointingobjcf = CFrame.new(rayobjectcf, Vector3.new(rayobjectcf.X,0, rayobjectcf.Z))
	elseif rayobjectcf.Z >= Zside or rayobjectcf.Z <= -Zside then
		pointingobjcf = CFrame.new(rayobjectcf, Vector3.new(rayobjectcf.X, rayobjectcf.Y, 0)) 
	end
	return part.CFrame:ToWorldSpace(pointingobjcf)
end


-- handles the ray casting and bullet effects on the server
fireevent.OnServerInvoke = function(plr, camray)
	local ammodata = SS.AmmoData:FindFirstChild(plr.Name .. "Ammo")
	local weapontype = ammodata.Weapon.Value
	local maxbullets = _G.weapondata[string.lower(weapontype .. "data")]["maxbullets"]
	if ammodata.Value <= 0 or ammodata == nil or ammodata.Value > 16 then return 0 end 
	local raysettings = RaycastParams.new()
	local filtertable = {}
	for i,v in pairs(plr.Character:GetChildren()) do
		table.insert(filtertable, v)
	end
	for i,v in pairs(game.Workspace.Aesthetics:GetChildren()) do
		table.insert(filtertable, v)
	end
	raysettings.FilterDescendantsInstances = filtertable
	raysettings.FilterType = Enum.RaycastFilterType.Blacklist
	local raycastres = workspace:Raycast(camray.Origin,camray.Direction * 300,raysettings) 
	if raycastres ~= nil then
		local hitpart = raycastres.Instance
		local hitpos = raycastres.Position
		local humanoid = hitpart.Parent:FindFirstChild("Humanoid")
		local bulletdebris = SS.Aesthetics.BulletDebris:Clone()
		bulletdebris.Parent = game.Workspace.Aesthetics
		bulletdebris.Decal.Color3 = hitpart.Color
		-- find part surface 
		local pointedsurface = surfacepointer(hitpos, hitpart)
		bulletdebris.CFrame = pointedsurface
		debris:AddItem(bulletdebris, 8)
		if humanoid ~= nil then
			bulletdebris.Decal.Color3 = Color3.fromRGB(200,0,0)
			local blood = SS.Aesthetics.Damaged:Clone()
			blood.Parent = hitpart
			debris:AddItem(blood, 0.4)
			if humanoid.Health <= 0 then return end
			local humhealth = humanoid.Health
			local hs = false 
			local dist = (camray.Origin - hitpos).Magnitude
			print("Distance: " .. dist)
			local dmg = math.floor(_G.weapondata[string.lower(weapontype .. "data")]["maxdmg"] * 5^-(dist/50))
			if hitpart.Name == "Head" then
				hs = true
				dmg = dmg * 2 
			end
			if dmg > humhealth then
				dmg = humhealth
			end
			humanoid:TakeDamage(dmg)
			return true, true , dmg , hs
		else
			for i = 1,math.random(1,3) do
				local debristype = SS.Aesthetics:FindFirstChild("Debris" .. math.random(1,2)):Clone()
				debristype.Parent = game.Workspace.Aesthetics
				debristype.CFrame = pointedsurface
				debristype.Color = hitpart.Color
				local force = Instance.new("BodyForce",debristype)
				local rawforce = pointedsurface:VectorToWorldSpace(Vector3.new(math.random(1,10)*0.01,math.random(1,10)*0.01,1) * math.random(13,15)*.1)
				if rawforce.Y >= 1.5 and debristype.Name == "Debris2" then
					rawforce = rawforce * 1.5
				elseif rawforce.Y >= 1.5 and debristype.Name == "Debris1" then
					rawforce = rawforce * 2
				end
				force.Force = rawforce
				spawn(function()
					wait(0.15)
					force:Destroy()
				end)
				debris:AddItem(debristype, 3.5)
			end
		end
	end
	ammodata.Value = ammodata.Value - 1
	local ammolabel = plr.PlayerGui.FPSGui.Ammo
	ammolabel.Text = ammodata.Value .. " / " .. maxbullets 
end

-- reloads the weapon
REvent.OnServerEvent:Connect(function(plr)
	local ammodata = SS.AmmoData:FindFirstChild(plr.Name .. "Ammo")
	if ammodata.Value == 16 then return end 
	if ammodata.Value <= 0 then
		--full reload
		ammodata.Value = 15
		local ammolabel = plr.PlayerGui.FPSGui.Ammo
		ammolabel.Text = ammodata.Value .. " / " .. 15
	elseif ammodata.Value <= 15 and ammodata.Value ~= 0 then
		--tactical reload
		ammodata.Value = 16
		local ammolabel = plr.PlayerGui.FPSGui.Ammo
		ammolabel.Text = ammodata.Value .. " / " .. 15
	end
end)

