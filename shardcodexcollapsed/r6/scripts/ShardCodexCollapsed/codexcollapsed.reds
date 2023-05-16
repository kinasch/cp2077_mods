@wrapMethod(CodexGameController)
protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    wrappedMethod(playerPuppet);

    let i: Int32 = 0;
    // Replace the 19 with the amount of levels from some method maybe?
    while i < 19 {
        if !this.m_listController.IsLevelToggled(i) {
            this.m_listController.ToggleLevel(i);
        }
        i += 1;
    };
}