@addField(AttackData)
private let critFlagBeforeProcessCriticalHitFlag: Bool;

@addMethod(AttackData)
public final func GetCritFlagBeforeProcessCriticalHitFlag() -> Bool {
  return this.critFlagBeforeProcessCriticalHitFlag;
}

@addMethod(AttackData)
public final func SetCritFlagBeforeProcessCriticalHitFlag(cFBPCHF: Bool) -> Void {
  this.critFlagBeforeProcessCriticalHitFlag = cFBPCHF;
}

@wrapMethod(DamageSystem)
protected final func GetCritDamageModifier(statSystem: ref<StatsSystem>, attackData: ref<AttackData>) -> Float {
	let accumulatedCritDamageBeforeCritConversion: Float;
	let playerCritChance: Float;
	let weaponCritChance: Float;
  let accumulatedCritChance: Float;
  let critConversionDamage: Float;

  let ratio: Float = 1.0;

  accumulatedCritDamageBeforeCritConversion = wrappedMethod(statSystem, attackData);

  //LogChannel(n"DEBUG", s"GetCritFlagBeforeProcessCriticalHitFlag \(attackData.GetCritFlagBeforeProcessCriticalHitFlag())");

	if IsDefined(attackData.GetInstigator()) {
    playerCritChance = statSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetInstigator().GetEntityID()), gamedataStatType.CritChance) / 100.00;
  };
  // This should mitigate the addition of weapon crit chance/damage for quickhacks
	if this.AllowWeaponCrit(attackData) {
    weaponCritChance = statSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetWeapon().GetEntityID()), gamedataStatType.CritChance) / 100.00;
  };

  // Add 100% to the crit chance, when the crit was flagged before "ProcessCriticalHit"
  // E.g. perfectly timed deflects (why? idk) or Cool_Master_Perk_4
  if attackData.GetCritFlagBeforeProcessCriticalHitFlag() || (Equals(this.GetSubAttackSubType(attackData), gamedataAttackSubtype.DeflectAttack) && PlayerDevelopmentSystem.GetData(attackData.GetInstigator()).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Reflexes_Right_Perk_2_2)) {
    // No idea, why the check after the || exists in the original method. 
    // Reflexes_Right_Perk_2_2 is "Seeing Double", thus should have nothing to do with Critical Hits...
    // Also, there is no check here, if the Instigator is even defined ?????
    accumulatedCritChance = playerCritChance + weaponCritChance + 1.0;
  } else {
    accumulatedCritChance = playerCritChance + weaponCritChance + attackData.GetAdditionalCritChance();
  }
  
  if accumulatedCritChance > 1.0 {
    critConversionDamage = accumulatedCritChance - 1.0;
  }

  //LogChannel(n"DEBUG", s"Crit Damage complete: \(accumulatedCritDamageBeforeCritConversion + (critConversionDamage * ratio)), Crit Chance \(playerCritChance), \(weaponCritChance), \(attackData.GetAdditionalCritChance()); acc: \(accumulatedCritChance)");
	return (accumulatedCritDamageBeforeCritConversion + (critConversionDamage * ratio));
}

@wrapMethod(DamageSystem)
public final func ProcessCriticalHit(hitEvent: ref<gameHitEvent>) -> Void {
  let attackData: ref<AttackData> = hitEvent.attackData;
  if attackData.HasFlag(hitFlag.CriticalHit) {
    attackData.SetCritFlagBeforeProcessCriticalHitFlag(true);
  };

  wrappedMethod(hitEvent);
}