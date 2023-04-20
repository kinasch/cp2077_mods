@wrapMethod(ShardsMenuGameController)
protected cb func OnInitialize() -> Bool {
    wrappedMethod();

    let i: Int32 = 0;
    // Replace the 12 with the amount of levels from some method maybe?
    while i < 12 {
        this.m_listController.ToggleLevel(i);
        i += 1;
    };
}