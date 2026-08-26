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
	if this.AllowWeaponCrit(attackData) {
    weaponCritChance = statSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetWeapon().GetEntityID()), gamedataStatType.CritChance) / 100.00;
  };

  accumulatedCritChance = playerCritChance + weaponCritChance + attackData.GetAdditionalCritChance();
  
  if accumulatedCritChance > 1.0 {
    critConversionDamage = accumulatedCritChance - 1.0;
  }

  //LogChannel(n"DEBUG", s"Crit Damage complete: \(accumulatedCritDamageBeforeCritConversion + (critConversionDamage * ratio)), Crit Chance \(playerCritChance), \(weaponCritChance)");

	return (accumulatedCritDamageBeforeCritConversion + (critConversionDamage * ratio));
}