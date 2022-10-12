hackingUtils = {}

-- Suicide QuickHack
function hackingUtils.setSpreadCountSuicide(count)
	TweakDB:SetFlat("QuickHack.SuicideHackBase_inline7.spreadCount",count)
end
function hackingUtils.setBonusJumpsSuicide(jumps)
	TweakDB:SetFlat("QuickHack.SuicideHackBase_inline7.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeSuicide(range)
	TweakDB:SetFlat("QuickHack.SuicideHackBase_inline7.spreadDistance",range)
end

-- System Reset (or Collapse) QuickHack
function hackingUtils.setSpreadCountSystemCollapse(count)
	TweakDB:SetFlat("QuickHack.SystemCollapseHackBase_inline6.spreadCount",count)
end
function hackingUtils.setBonusJumpsSystemCollapse(jumps)
	TweakDB:SetFlat("QuickHack.SystemCollapseHackBase_inline6.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeSystemCollapse(range)
	TweakDB:SetFlat("QuickHack.SystemCollapseHackBase_inline6.spreadDistance",range)
end

-- Contagion QuickHack
function hackingUtils.setSpreadCountContagion(count)
	TweakDB:SetFlat("QuickHack.BaseContagionHack_inline3.spreadCount",count)
end
function hackingUtils.setBonusJumpsContagion(jumps)
	TweakDB:SetFlat("QuickHack.BaseContagionHack_inline3.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeContagion(range)
	TweakDB:SetFlat("QuickHack.BaseContagionHack_inline3.spreadDistance",range)
end

-- Overheat QuickHack
function hackingUtils.setSpreadCountOverheat(count)
	TweakDB:SetFlat("QuickHack.BaseOverheatHack_inline3.spreadCount",count)
end
function hackingUtils.setBonusJumpsOverheat(jumps)
	TweakDB:SetFlat("QuickHack.BaseOverheatHack_inline3.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeOverheat(range)
	TweakDB:SetFlat("QuickHack.BaseOverheatHack_inline3.spreadDistance",range)
end

-- Blind QuickHack
function hackingUtils.setSpreadCountBlind(count)
	TweakDB:SetFlat("QuickHack.BaseBlindHack_inline6.spreadCount",count)
end
function hackingUtils.setBonusJumpsBlind(jumps)
	TweakDB:SetFlat("QuickHack.BaseBlindHack_inline6.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeBlind(range)
	TweakDB:SetFlat("QuickHack.BaseBlindHack_inline6.spreadDistance",range)
end

-- Cyberware Malfunction QuickHack
function hackingUtils.setSpreadCountCyberwareMalfunction(count)
	TweakDB:SetFlat("QuickHack.BaseCyberwareMalfunctionHack_inline5.spreadCount",count)
end
function hackingUtils.setBonusJumpsCyberwareMalfunction(jumps)
	TweakDB:SetFlat("QuickHack.BaseCyberwareMalfunctionHack_inline5.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeCyberwareMalfunction(range)
	TweakDB:SetFlat("QuickHack.BaseCyberwareMalfunctionHack_inline5.spreadDistance",range)
end

-- Locomotion Malfunction QuickHack
function hackingUtils.setSpreadCountLocomotionMalfunction(count)
	TweakDB:SetFlat("QuickHack.BaseLocomotionMalfunctionHack_inline4.spreadCount",count)
end
function hackingUtils.setBonusJumpsLocomotionMalfunction(jumps)
	TweakDB:SetFlat("QuickHack.BaseLocomotionMalfunctionHack_inline4.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeLocomotionMalfunction(range)
	TweakDB:SetFlat("QuickHack.BaseLocomotionMalfunctionHack_inline4.spreadDistance",range)
end

-- Weapon Malfunction QuickHack
function hackingUtils.setSpreadCountWeaponMalfunction(count)
	TweakDB:SetFlat("QuickHack.BaseWeaponMalfunctionHack_inline4.spreadCount",count)
end
function hackingUtils.setBonusJumpsWeaponMalfunction(jumps)
	TweakDB:SetFlat("QuickHack.BaseWeaponMalfunctionHack_inline4.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeWeaponMalfunction(range)
	TweakDB:SetFlat("QuickHack.BaseWeaponMalfunctionHack_inline4.spreadDistance",range)
end

-- Detonate Grenade QuickHack
function hackingUtils.setSpreadCountDetonateGrenade(count)
	TweakDB:SetFlat("QuickHack.GrenadeHackBase_inline6.spreadCount",count)
end
function hackingUtils.setBonusJumpsDetonateGrenade(jumps)
	TweakDB:SetFlat("QuickHack.GrenadeHackBase_inline6.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeDetonateGrenade(range)
	TweakDB:SetFlat("QuickHack.GrenadeHackBase_inline6.spreadDistance",range)
end

-- Overload/Short Circuit QuickHack
function hackingUtils.setSpreadCountOverload(count)
	TweakDB:SetFlat("QuickHack.OverloadBaseHack_inline6.spreadCount",count)
end
function hackingUtils.setBonusJumpsOverload(jumps)
	TweakDB:SetFlat("QuickHack.OverloadBaseHack_inline6.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeOverload(range)
	TweakDB:SetFlat("QuickHack.OverloadBaseHack_inline6.spreadDistance",range)
end

-- Brain Melt/Synapse Burnout QuickHack
function hackingUtils.setSpreadCountBrainMelt(count)
	TweakDB:SetFlat("QuickHack.BrainMeltBaseHack_inline3.spreadCount",count)
end
function hackingUtils.setBonusJumpsBrainMelt(jumps)
	TweakDB:SetFlat("QuickHack.BrainMeltBaseHack_inline3.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeBrainMelt(range)
	TweakDB:SetFlat("QuickHack.BrainMeltBaseHack_inline3.spreadDistance",range)
end

-- Cyberpsychosis QuickHack
function hackingUtils.setSpreadCountCyberpsychosis(count)
	TweakDB:SetFlat("QuickHack.MadnessHackBase_inline6.spreadCount",count)
end
function hackingUtils.setBonusJumpsCyberpsychosis(jumps)
	TweakDB:SetFlat("QuickHack.MadnessHackBase_inline6.bonusJumps",jumps)
end
function hackingUtils.setSpreadRangeCyberpsychosis(range)
	TweakDB:SetFlat("QuickHack.MadnessHackBase_inline6.spreadDistance",range)
end

return hackingUtils