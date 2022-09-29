local plr = game.Players.LocalPlayer
repeat wait() until plr.Character
local char = plr.Character
local hum = char:WaitForChild("Humanoid")
local mainframe = script.Parent
local healthbar = mainframe.HealthBar
local backframe = mainframe.BackgroundFrame
local prevhealth = hum.Health
local camera = game.Workspace.CurrentCamera
local damageblur = Instance.new("BlurEffect",camera)
damageblur.Name = "DamageBlur"
damageblur.Enabled = false
damageblur.Size = 15
local weakblur = damageblur:Clone()
weakblur.Name = "WeakBlur"
weakblur.Parent = camera
--tweeninfo 
local BlackOut = mainframe.Parent:WaitForChild("BlackOut")
local plrgui = plr:WaitForChild("PlayerGui")
local weak = false
local blurringdb = false
mainframe.Health.Text = hum.Health .. " / " .. hum.MaxHealth


-- add a heart to the left of the health bar?
hum.HealthChanged:Connect(function(newhealth)
	healthbar.Size = UDim2.fromScale(newhealth/100,1)
	mainframe.Health.Text = math.floor(newhealth) .. " / " .. hum.MaxHealth
	if newhealth < 25 then
		weak = true
		healthbar.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
		mainframe.Health.TextColor3 = Color3.fromRGB(193, 109, 34)
	elseif newhealth > 25 then
		weak = false
		mainframe.Health.TextColor3 = Color3.fromRGB(0, 148, 0)
		healthbar.BackgroundColor3 = Color3.fromRGB(66, 180, 58)
	end
	if newhealth < prevhealth then
		damageblur.Enabled = true
		wait(0.1)
		damageblur.Enabled = false
	end
	prevhealth = newhealth
	wait(2.5)
	local currenthealth = healthbar.Size
	backframe:TweenSize(currenthealth, Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1.5)
	if weak and not blurringdb then
		blurringdb = true
		wait(6)
		weakblur.Enabled = true
		for i = 1,15 do
			wait()
			weakblur.Size = i
		end
		wait(0.1)
		for i = 15,1,-1 do
			wait()
			weakblur.Size = i
		end
		weakblur.Enabled = false
		blurringdb = false
	end
	
end)
-- blackout effect
hum.Died:Connect(function()
	for i = 1,0,-0.01 do
		wait()
		BlackOut.BackgroundTransparency = i
	end
	damageblur.Enabled = false
end)
