local infAmmoToggled = false
local notifTimer = 0

registerForEvent("onInit", function()
	Observe('WeaponObject', 'SendAmmoUpdateEvent;GameObjectWeaponObject', function(gameObject, weapon)
		local player = Game.GetPlayer()
		local activeWeapon = GameObject.GetActiveWeapon(player)
		if activeWeapon:GetItemID() == weapon:GetItemID() and infAmmoToggled == true then
			triggerInfiniteAmmo()
		end
		
	end)
end)

registerForEvent("onDraw", function()
	if notifTimer > 0 then
		drawNotificationWindow()
		notifTimer = notifTimer - 1
	end
end)



registerHotkey("toggleInfiniteAmmo", "Toggle Infinite Ammunition", function()
	if infAmmoToggled == true then
		Game.GetInventoryManager().RemoveEquipmentStateFlag(Game.GetInventoryManager(),gameEEquipmentManagerState.InfiniteAmmo)
		infAmmoToggled = false
		notifTimer = 200
	elseif infAmmoToggled == false then
		Game.GetInventoryManager().AddEquipmentStateFlag(Game.GetInventoryManager(),gameEEquipmentManagerState.InfiniteAmmo)
		infAmmoToggled = true
		notifTimer = 200
	end
end)

function triggerInfiniteAmmo()
	local player = Game.GetPlayer()
	local activeWeapon = GameObject.GetActiveWeapon(player)
	-- The gist behind this is:
	-- Reload the weapon in 0 seconds, end the reload
	GameObject.GetActiveWeapon(player).StartReload(activeWeapon,0)
	GameObject.GetActiveWeapon(player).StopReload(activeWeapon,gameweaponReloadStatus.Standard)
end

function drawNotificationWindow()
	ImGui.SetNextWindowPos(20, 100, ImGuiCond.Always)
	ImGui.SetNextWindowSize(200, 50)
	if (ImGui.Begin("Infinite Ammo")) then
		local toggleStatus = infAmmoToggled and "Toggled On" or "Toggled Off"
		ImGui.Text(tostring(toggleStatus))
	end
	ImGui.End()
end