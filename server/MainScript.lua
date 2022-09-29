_G.RegisterPlayerWeapon = function(plr, weapontype, register)
	local SS = game:GetService("ServerStorage")
	local ammolabel = plr.PlayerGui:WaitForChild("FPSGui").Ammo
	local ammostorage = SS.AmmoData
	if register then
		local bulletcount = Instance.new("IntValue", ammostorage)
		bulletcount.Name = plr.Name .. "Ammo"
		local weaponstore = Instance.new("StringValue",bulletcount)
		weaponstore.Name = "Weapon"
		if weapontype == "Pistol" then
			local pistolbehave = SS.WeaponScripts.PistolBehaviours:Clone()
			pistolbehave.Disabled = false
			pistolbehave.Parent = plr.Character
			weaponstore.Value = weapontype
			bulletcount.Value = _G.weapondata["pistoldata"]["maxbullets"] + 1 
			ammolabel.Text = bulletcount.Value .. " / " .. _G.weapondata["pistoldata"]["maxbullets"]
			local unarmedscript = plr.Character:FindFirstChild("UnarmedBehaviours")
			if unarmedscript ~= nil then
				unarmedscript:Destroy()
			end	
		elseif weapontype == "Shotgun" then
			weaponstore.Value = weapontype
			bulletcount.Value = _G.weapondata["shotgundata"]["maxbullets"] + 1 
			ammolabel.Text = bulletcount.Value .. " / " .. _G.weapondata["shotgundata"]["maxbullets"]
			local unarmedscript = plr.Character:FindFirstChild("UnarmedBehaviours")
			if unarmedscript ~= nil then
				unarmedscript:Destroy()
			end	
		end
	elseif not register then
		local data = ammostorage:WaitForChild(plr.Name .. "Ammo")
		data:Destroy()
		local unarmed = SS.WeaponScripts:FindFirstChild("UnarmedBehaviours")
		if unarmed ~= nil then
			local plrunarmed = unarmed:Clone()
			plrunarmed.Disabled = false
			plrunarmed.Parent = plr.Character
		end
	end
end
game.Players.PlayerAdded:Connect(function(plr)
	wait(5)
	_G.RegisterPlayerWeapon(plr,"Pistol",true)
	plr.CharacterAdded:Connect(function(char)
		local animate = char:WaitForChild("Animate")
		animate.Run.RunAnim.AnimationId = "rbxassetid://356"
		animate.Idle.Animation1.AnimationId = "rbxassetid://356"
		animate.Idle.Animation1.AnimationId = "rbxassetid://356"

	end)
end)
