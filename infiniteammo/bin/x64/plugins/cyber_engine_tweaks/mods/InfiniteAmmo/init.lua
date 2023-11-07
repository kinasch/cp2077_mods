local infAmmoToggled = false
local notifTimer = 0

registerForEvent("onInit", function()
	local refundEvent = SetAmmoCountEvent.new()
	
	ObserveBefore('WeaponObject', 'SendAmmoUpdateEvent;GameObjectWeaponObject', function(gameObject, weapon)
		local player = Game.GetPlayer()
		local activeWeapon = player:GetActiveWeapon()
		if activeWeapon:GetItemID() == weapon:GetItemID() and infAmmoToggled == true then
			refundEvent.ammoTypeID = WeaponObject.GetAmmoType(weapon)
			refundEvent.count = WeaponObject.GetMagazineCapacity(weapon) 
		
			weapon:QueueEvent(refundEvent)
		end
		
	end)
end)

registerHotkey("toggleInfiniteAmmo", "Toggle Infinite Ammunition", function()
	if infAmmoToggled == true then
		Game.GetInventoryManager().RemoveEquipmentStateFlag(Game.GetInventoryManager(),gameEEquipmentManagerState.InfiniteAmmo)
		infAmmoToggled = false
		notifTimer = 200
	elseif infAmmoToggled == false then
		-- No idea how to instantly reload / skip the reload anim when equipping an empty weapon or toggling the mod with an empty weapon.
		Game.GetInventoryManager().AddEquipmentStateFlag(Game.GetInventoryManager(),gameEEquipmentManagerState.InfiniteAmmo)
		
		-- Maybe give back the ammo spent on the infinite ammo algorithm? With give item and what not...
		
		infAmmoToggled = true
		notifTimer = 200
	end
end)

registerForEvent("onDraw", function()
	if notifTimer > 0 then
		drawNotificationWindow()
		notifTimer = notifTimer - 1
	end
end)

function drawNotificationWindow()
	ImGui.SetNextWindowPos(20, 100, ImGuiCond.Always)
	ImGui.SetNextWindowSize(150, 80)
	if (ImGui.Begin("Infinite Ammo")) then
		local toggleStatus = infAmmoToggled and "Toggled On" or "Toggled Off"
		ImGui.Text(tostring(toggleStatus))
	end
	ImGui.End()
end