@addMethod(PlayerDevelopmentData)
public final const func GetBoughtPerks() -> array<SPerk> {
	let count: Int32 = ArraySize(this.m_perkAreas);
    let i: Int32 = 0;
	let allBoughtPerks: array<SPerk>;
    while i < count {
		let j: Int32 = 0;
		let perkCount: Int32 = ArraySize(this.m_perkAreas[i].boughtPerks);
		while j < perkCount {
			ArrayPush(allBoughtPerks,this.m_perkAreas[i].boughtPerks[j]);
			j += 1;
		}
		i += 1;
	}
	return allBoughtPerks;
}

@addMethod(PlayerDevelopmentData)
public final const func GetBoughtTraits() -> array<STrait> {
	let count: Int32 = ArraySize(this.m_traits);
    let i: Int32 = 0;
	let allBoughtTraits: array<STrait>;
    while i < count {
		ArrayPush(allBoughtTraits,this.m_traits[i]);
		i += 1;
	}
	return allBoughtTraits;
}

@addMethod(PlayerDevelopmentData)
public final const func ResetSpentDevPoints(type: gamedataDevelopmentPointType) -> Void {
	let dIndex: Int32 = this.GetDevPointsIndex(type);
    if dIndex < 0 {
      LogDM("ResetDevelopmentPoints(): Given type doesn\'t exist!");
      return;
    };
	this.m_devPoints[dIndex].spent = 0;
}

@addMethod(PlayerDevelopmentData)
public final const func GetProficiencyExperience(type: gamedataProficiencyType) -> Int32 {
    let pIndex: Int32 = this.GetProficiencyIndexByType(type);

	return this.m_proficiencies[pIndex].currentExp;
}

@addMethod(PlayerDevelopmentData)
public final const func LockTraitOfProf(profType: gamedataProficiencyType) -> Void {
    let traitType: gamedataTraitType = RPGManager.GetProficiencyRecord(profType).Trait().Type();
    let traitIndex: Int32 = this.GetTraitIndex(traitType);

	if traitIndex < 0 {
    	return;
    };

	this.m_traits[traitIndex].unlocked = false;
    this.DeactivateTraitBase(this.m_traits[traitIndex].type);
}

@addMethod(PlayerDevelopmentData)
private final const func DeactivateTraitBase(traitType: gamedataTraitType) -> Void {
    let traitPackage: TweakDBID = RPGManager.GetTraitRecord(traitType).BaseTraitData().DataPackage().GetID();
    GameInstance.GetGameplayLogicPackageSystem(this.m_owner.GetGame()).RemovePackage(this.m_owner, traitPackage);
}