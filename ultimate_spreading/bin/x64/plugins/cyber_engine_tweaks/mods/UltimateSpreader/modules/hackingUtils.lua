hackingUtils = {}

-- Suicide QuickHack
function hackingUtils.setSpreadCountSuicide(count)
	TweakDB:SetFlat("QuickHack.SuicideHackBase_inline7.spreadCount",count)
end
function hackingUtils.setSpreadRangeSuicide(range)
	TweakDB:SetFlat("QuickHack.SuicideHackBase_inline7.spreadDistance",range)
end

-- System Reset (or Collapse) QuickHack
function hackingUtils.setSpreadCountSystemCollapse(count)
	TweakDB:SetFlat("QuickHack.SystemCollapseHackBase_inline6.spreadCount",count)
end
function hackingUtils.setSpreadRangeSystemCollapse(range)
	TweakDB:SetFlat("QuickHack.SystemCollapseHackBase_inline6.spreadDistance",range)
end

return hackingUtils