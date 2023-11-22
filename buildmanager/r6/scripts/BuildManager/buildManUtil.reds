@replaceMethod(NewPerksCategoriesGameController)
protected cb func OnResetConfirmed(data: ref<inkGameNotificationData>) -> Bool {
let resultData: ref<GenericMessageNotificationCloseData> = data as GenericMessageNotificationCloseData;
this.m_resetConfirmationToken = null;
    if IsDefined(resultData) && Equals(resultData.result, GenericMessageNotificationResult.Yes) {
        PlayerDevelopmentSystem.GetData(this.m_player).ResetNewPerks();
        PlayerDevelopmentSystem.GetData(this.m_player).ResetAttributes();
        this.QueueEvent(new PlayerDevUpdateDataEvent());
        inkWidgetRef.SetVisible(this.m_resetAttributesButton, true);
        this.PlaySound(n"Attributes", n"OnDone");
        this.PlayLibraryAnimation(n"panel_categories_reset_attributes");
    };
}

@addMethod(PlayerDevelopmentData)
public final const func GetAttributesData() -> array<SAttributeData> {
    return this.m_attributesData;
}

@addMethod(PlayerDevelopmentData)
public final const func GetProficiencyExperience(type: gamedataProficiencyType) -> Int32 {
    let pIndex: Int32 = this.GetProficiencyIndexByType(type);
    return this.m_proficiencies[pIndex].currentExp;
}