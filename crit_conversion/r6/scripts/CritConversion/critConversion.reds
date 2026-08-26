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

	if IsDefined(attackData.GetInstigator()) {
    playerCritChance = statSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetInstigator().GetEntityID()), gamedataStatType.CritChance) / 100.00;
  };
  // This should mitigate the addition of weapon crit chance/damage for quickhacks
	if this.AllowWeaponCrit(attackData) {
    weaponCritChance = statSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetWeapon().GetEntityID()), gamedataStatType.CritChance) / 100.00;
  };

  // Include the additional crit chance (e.g. the guaranteed crit of the Sovereign) or just add if the crit flag was set before the "ProcessCriticalHit" method set it manually.
  if attackData.GetAdditionalCritChance() < 1.0 && attackData.GetCritFlagBeforeProcessCriticalHitFlag() {
    accumulatedCritChance = playerCritChance + weaponCritChance + 1.0;
  } else {
    accumulatedCritChance = playerCritChance + weaponCritChance + attackData.GetAdditionalCritChance();
  }
  
  if accumulatedCritChance > 1.0 {
    critConversionDamage = accumulatedCritChance - 1.0;
  }

  //LogChannel(n"DEBUG", s"Crit Damage complete: \(accumulatedCritDamageBeforeCritConversion + (critConversionDamage * ratio)), Crit Chance \(playerCritChance), \(weaponCritChance); acc: \(accumulatedCritChance)");
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