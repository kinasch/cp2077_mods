local infAmmoToggled = false

registerForEvent("onInit", function()
	Observe('WeaponObject', 'SendAmmoUpdateEvent;GameObjectWeaponObject', function(gameObject, weapon)
		local player = Game.GetPlayer()
		local activeWeapon = GameObject.GetActiveWeapon(player)
		if activeWeapon:GetItemID() == weapon:GetItemID() and infAmmoToggled == true then
			TriggerInfiniteAmmo()
		end
		
	end)
end)

registerHotkey("toggleInfiniteAmmo", "Toggle Infinite Ammunition", function()
	if infAmmoToggled == true then
		Game.GetInventoryManager().RemoveEquipmentStateFlag(Game.GetInventoryManager(),gameEEquipmentManagerState.InfiniteAmmo)
		infAmmoToggled = false
	elseif infAmmoToggled == false then
		Game.GetInventoryManager().AddEquipmentStateFlag(Game.GetInventoryManager(),gameEEquipmentManagerState.InfiniteAmmo)
		infAmmoToggled = true
	end
end)

function TriggerInfiniteAmmo()
	local player = Game.GetPlayer()
	local activeWeapon = GameObject.GetActiveWeapon(player)
	-- The gist behind this is:
	-- Reload the weapon in 0 seconds, end the reload
	GameObject.GetActiveWeapon(player).StartReload(activeWeapon,0)
	GameObject.GetActiveWeapon(player).StopReload(activeWeapon,gameweaponReloadStatus.Standard)
end