@addMethod(PlayerDevelopmentData)
public final const func GetAttributesData() -> array<SAttributeData> {
    return this.m_attributesData;
}

@addMethod(PlayerDevelopmentData)
public final const func GetProficiencyExperience(type: gamedataProficiencyType) -> Int32 {
    let pIndex: Int32 = this.GetProficiencyIndexByType(type);
    return this.m_proficiencies[pIndex].currentExp;
}