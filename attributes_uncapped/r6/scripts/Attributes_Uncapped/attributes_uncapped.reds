@addMethod(PlayerDevelopmentSystem)
public static func GetAttributesUncappedCap() -> Int32 {
	return 10000;
}

@replaceMethod(PlayerDevelopmentDataManager)
private final func FillAttributeData(attribute: SAttribute, out outData: ref<AttributeData>) -> Void {
	if Equals(attribute.attributeName, gamedataStatType.Espionage) {
	  outData.label = "LocKey#20997";
	} else {
	  outData.label = TweakDBInterface.GetStatRecord(TDBID.Create("BaseStats." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(attribute.attributeName))))).LocalizedName();
	};
	outData.value = attribute.value;
	outData.maxValue = PlayerDevelopmentSystem.GetAttributesUncappedCap();
	outData.id = attribute.id;
	outData.availableToUpgrade = outData.value < outData.maxValue;
	outData.type = attribute.attributeName;
	outData.description = TweakDBInterface.GetStatRecord(TDBID.Create("BaseStats." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(attribute.attributeName))))).LocalizedDescription();
}

@wrapMethod(PerkMenuTooltipController)
public func SetData(tooltipData: ref<ATooltipData>) -> Void {
  this.m_maxProficiencyLevel = PlayerDevelopmentSystem.GetAttributesUncappedCap();
  wrappedMethod(tooltipData);
}