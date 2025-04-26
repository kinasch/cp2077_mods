public class AttributeUncapped {
	public static func GetCap() -> Int32 {
		return 100;
	}
}

@replaceMethod(PlayerDevelopmentDataManager)
private final func FillAttributeData(attribute: SAttribute, out outData: ref<AttributeData>) -> Void {
	if Equals(attribute.attributeName, gamedataStatType.Espionage) {
	  outData.label = "LocKey#20997";
	} else {
	  outData.label = TweakDBInterface.GetStatRecord(TDBID.Create("BaseStats." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(attribute.attributeName))))).LocalizedName();
	};
	outData.value = attribute.value;
	outData.maxValue = AttributeUncapped.GetCap();
	outData.id = attribute.id;
	outData.availableToUpgrade = outData.value < outData.maxValue;
	outData.type = attribute.attributeName;
	outData.description = TweakDBInterface.GetStatRecord(TDBID.Create("BaseStats." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(attribute.attributeName))))).LocalizedDescription();
}

@wrapMethod(PerkMenuTooltipController)
public func SetData(tooltipData: ref<ATooltipData>) -> Void {
  this.m_maxProficiencyLevel = AttributeUncapped.GetCap();
  wrappedMethod(tooltipData);
}