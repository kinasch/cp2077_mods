@addMethod(PlayerDevelopmentData)
public final const func GetAttributesData() -> array<SAttributeData> {
    return this.m_attributesData;
}

@addMethod(PlayerDevelopmentData)
public final const func GetProficiencyExperience(type: gamedataProficiencyType) -> Int32 {
    let pIndex: Int32 = this.GetProficiencyIndexByType(type);
    return this.m_proficiencies[pIndex].currentExp;
}

@addMethod(EquipmentSystemPlayerData)
private final func GetAllEquippedItems() -> [SItemInfo] {
  let areasToSave: array<gamedataEquipmentArea>;
  let items: array<SItemInfo>;
  let itemInfo: SItemInfo;
  let i: Int32;
  let j: Int32;
  // Cyberware
  ArrayPush(areasToSave, gamedataEquipmentArea.SystemReplacementCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.ArmsCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.HandsCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.CardiovascularSystemCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.EyesCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.LegsCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.FrontalCortexCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.IntegumentarySystemCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.MusculoskeletalSystemCW);
  ArrayPush(areasToSave, gamedataEquipmentArea.NervousSystemCW);
  // Weapons
  ArrayPush(areasToSave, gamedataEquipmentArea.Weapon);
  // Clothing
  ArrayPush(areasToSave, gamedataEquipmentArea.InnerChest);
  ArrayPush(areasToSave, gamedataEquipmentArea.OuterChest);
  ArrayPush(areasToSave, gamedataEquipmentArea.Face);
  ArrayPush(areasToSave, gamedataEquipmentArea.Head);
  ArrayPush(areasToSave, gamedataEquipmentArea.Legs);
  ArrayPush(areasToSave, gamedataEquipmentArea.Feet);
  i = 0;
  while i < ArraySize(this.m_equipment.equipAreas) {
    if ArrayContains(areasToSave, this.m_equipment.equipAreas[i].areaType) {
      j = 0;
      while j < ArraySize(this.m_equipment.equipAreas[i].equipSlots) {
        itemInfo.itemID = this.GetOriginalItemIDIfItemIsSideEquipped(this.m_equipment.equipAreas[i].equipSlots[j].itemID);
        itemInfo.slotIndex = j;
        ArrayPush(items, itemInfo);
        j += 1;
      };
    };
    i += 1;
  };
  return items;
}

@addMethod(EquipmentSystemPlayerData)
private final func EquipAllItemsFromList(items: array<SItemInfo>) -> Void {
  let itemToEquip: ItemID;
  let j: Int32;
  let slotIndex: Int32;
  while j < ArraySize(items) {
    itemToEquip = items[j].itemID;
    slotIndex = items[j].slotIndex;
    if GameInstance.GetTransactionSystem(this.m_owner.GetGame()).HasItem(this.m_owner, itemToEquip) {
      this.EquipItem(itemToEquip, slotIndex, false);
    };
    j += 1;
  };
}

@addMethod(EquipmentSystemPlayerData)
private final func GetOriginalItemIDIfItemIsSideEquipped(itemID: ItemID) -> ItemID {
  let sideUpgradeItem: ref<Item_Record>;
  if ItemID.IsValid(itemID) && Equals(EquipmentSystem.GetEquipAreaType(itemID), gamedataEquipmentArea.MusculoskeletalSystemCW) && !RPGManager.CyberwareHasSideUpgrade(itemID, sideUpgradeItem) {
    return this.GetOriginalItemIDFromSideUpgrade(itemID);
  } else {
    return itemID;
  };
}

public struct CyberwarePartBuildManager{
  public let partID: ItemID;
  public let slot: TweakDBID;
}

@addMethod(EquipmentSystemPlayerData)
private final func GetPartsFromItem(cyberwareItemID: ItemID) -> array<CyberwarePartBuildManager> {
  let i: Int32;
  let partData: InnerItemData;
  let staticData: wref<Item_Record>;
  let usedSlots: array<TweakDBID>;
  let curCyberwarePart: CyberwarePartBuildManager;
  let cyberwareParts: array<CyberwarePartBuildManager>;
  let cyberwareData: wref<gameItemData>;
  let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.m_owner.GetGame());
  transactionSystem.GetUsedSlotsOnItem(this.m_owner, cyberwareItemID, usedSlots);
  cyberwareData = RPGManager.GetItemData(this.m_owner.GetGame(), this.m_owner, cyberwareItemID);
  i = 0;
  while i < ArraySize(usedSlots) {
    if usedSlots[i] == t"AttachmentSlots.StatsShardSlot" || usedSlots[i] == t"AttachmentSlots.GenericItemRoot" || usedSlots[i] == t"" {
    } else {
      cyberwareData.GetItemPart(partData, usedSlots[i]);
      staticData = InnerItemData.GetStaticData(partData);
      if IsDefined(staticData) && staticData.TagsContains(n"DummyPart") {
      } else {
        curCyberwarePart.partID = partData.GetItemID();
        curCyberwarePart.slot = usedSlots[i];
        ArrayPush(cyberwareParts, curCyberwarePart);
      };
    };
    i += 1;
  };
  return cyberwareParts;
}

@addMethod(EquipmentSystemPlayerData)
private final func ClearCyberwareWeaponsAndClothes() -> Void {
  let equipArea: SEquipArea;
  let j: Int32;
  let i: Int32 = 0;
  let equipmentAreas: array<SEquipArea>;
  while i < ArraySize(this.m_equipment.equipAreas) {
    equipArea = this.m_equipment.equipAreas[i];
    if NotEquals(equipArea.areaType, gamedataEquipmentArea.RightArm) && NotEquals(equipArea.areaType, gamedataEquipmentArea.PersonalLink) && NotEquals(equipArea.areaType, gamedataEquipmentArea.BaseFists) && NotEquals(equipArea.areaType, gamedataEquipmentArea.VDefaultHandgun) && NotEquals(equipArea.areaType, gamedataEquipmentArea.SilverhandArm) && NotEquals(equipArea.areaType, gamedataEquipmentArea.PlayerTattoo) {
      j = 0;
      while j < ArraySize(equipArea.equipSlots) {
        this.UnequipItem(i, j);
        j += 1;
      };
    };
    i += 1;
  };
}