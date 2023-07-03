@addField(SpreadInitEffector)
public let m_sCount: Int32;

@addField(SpreadInitEffector)
public let m_bJumps: Int32;

@addField(SpreadInitEffector)
public let m_ran: Float;

@wrapMethod(SpreadInitEffector)
protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
  wrappedMethod(record, game, parentRecord);

  let statsSystem: ref<StatsSystem>;
  statsSystem = GameInstance.GetStatsSystem(this.m_player.GetGame());
  if !IsDefined(statsSystem) {
    return;
  };

  this.m_sCount = this.m_effectorRecord.SpreadCount();
  if this.m_sCount < 0 {
    this.m_sCount = Cast<Int32>(statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.QuickHackSpreadNumber));
  };

  this.m_bJumps = this.m_effectorRecord.BonusJumps();

  this.m_ran = Cast<Float>(this.m_effectorRecord.SpreadDistance());
  if this.m_ran < 0.00 {
    this.m_ran = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.QuickHackSpreadDistance);
  };
}

@replaceMethod(SpreadInitEffector)
protected func ActionOn(owner: ref<GameObject>) -> Void {
  let range: Float;
  let spreadCount: Int32;
  let statsSystem: ref<StatsSystem>;
  if !IsDefined(owner) || !IsDefined(this.m_objectActionRecord) || !IsDefined(this.m_effectorRecord) {
    return;
  };
  if !IsDefined(this.m_player) {
    return;
  };
  statsSystem = GameInstance.GetStatsSystem(this.m_player.GetGame());
  if !IsDefined(statsSystem) {
    return;
  };
  spreadCount = this.m_sCount;
  if spreadCount < 0 {
    spreadCount = Cast<Int32>(statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.QuickHackSpreadNumber));
  };
  range = this.m_ran;
  if range < 0.00 {
    range = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.QuickHackSpreadDistance);
  };
  spreadCount += this.m_bJumps;
  if spreadCount <= 0 || range <= 0.00 {
    return;
  };
  HackingDataDef.AddItemToSpreadMap(this.m_player, this.m_objectActionRecord.ObjectActionUI(), spreadCount, range);
}



// Notes for CET:
// ObserveBefore('SpreadInitEffector','ActionOn;GameObject',function(self, o) self.sCount = 10 end)
// 
// This means A LOT of observation, thus idk if this is a good idea.
// Setting up observers for every hack and manually set values in a table, which the observers access?