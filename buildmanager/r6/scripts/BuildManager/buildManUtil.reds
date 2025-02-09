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
private final func GetAllCyberwareItems() -> [SItemInfo] {
  let areasToSave: array<gamedataEquipmentArea>;
  let items: array<SItemInfo>;
  let itemInfo: SItemInfo;
  let i: Int32;
  let j: Int32;
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

// Currently removes all Quickhacks! (or other cyberware parts, should only be cyberdecks tho)
@addMethod(EquipmentSystemPlayerData)
private final func EquipAllCyberware(items: array<SItemInfo>) -> Void {
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