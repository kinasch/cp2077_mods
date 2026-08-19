module UltimateSpreader

@if(!ModuleExists("OpCyberdeckMod") && ModuleExists("ModSettingsModule"))
public class SpreaderSettings extends ScriptableSystem {
    // ========================================================================
    // Individual Settings Switch
    // ========================================================================
    
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.displayName", "Use Individual Settings")
    @runtimeProperty("ModSettings.description", "ON: Use individual quickhack sliders below.\nOFF: Use the Global Spread sliders for everything.")
    public let useIndividualSettings: Bool = false;

    // ========================================================================
    // GLOBAL SETTINGS
    // ========================================================================

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Global Settings")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Global Spread Distance")
    @runtimeProperty("ModSettings.description", "Default radius if Individual Settings are OFF.")
    @runtimeProperty("ModSettings.step", "1.0")
    @runtimeProperty("ModSettings.min", "5.0")
    @runtimeProperty("ModSettings.max", "100.0")
    public let globalSpreadRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Global Settings")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Global Spread Count")
    @runtimeProperty("ModSettings.description", "Default max targets if Individual Settings are OFF.")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "15")
    public let globalMaxTargets: Int32 = 4;


    // ========================================================================
    // COMBAT QUICKHACKS 
    // ========================================================================

    // Visual Header for Combat Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- COMBAT QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.displayName", "Quickhacks in this group:")
    private let headerCombat: Bool = false;

    // Short Circuit (Technical Name: Overload)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Short Circuit")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let shortCircuitRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Short Circuit")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let shortCircuitCount: Int32 = 4;

    // Overheat (Technical Name: Overheat)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Overheat")
    @runtimeProperty("ModSettings.category.order", "4")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let overheatRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Overheat")
    @runtimeProperty("ModSettings.category.order", "4")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let overheatCount: Int32 = 4;

    // Contagion (Technical Name: Contagion)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Contagion")
    @runtimeProperty("ModSettings.category.order", "5")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let contagionRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Contagion")
    @runtimeProperty("ModSettings.category.order", "5")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let contagionCount: Int32 = 4;

    // Synapse Burnout (Technical Name: BrainMelt)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Synapse Burnout")
    @runtimeProperty("ModSettings.category.order", "6")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let synapseBurnoutRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Synapse Burnout")
    @runtimeProperty("ModSettings.category.order", "6")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let synapseBurnoutCount: Int32 = 4;


    // ========================================================================
    // CONTROL QUICKHACKS
    // ========================================================================

    // Visual Header for Control Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- CONTROL QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "7")
    @runtimeProperty("ModSettings.displayName", "Quickhacks in this group:")
    public let headerControl: Bool = false;

    // Reboot Optics (Technical Name: Blind)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Reboot Optics")
    @runtimeProperty("ModSettings.category.order", "8")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let rebootOpticsRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Reboot Optics")
    @runtimeProperty("ModSettings.category.order", "8")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let rebootOpticsCount: Int32 = 4;

    // Weapon Glitch (Technical Name: Malfunction)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Weapon Glitch")
    @runtimeProperty("ModSettings.category.order", "9")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let weaponGlitchRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Weapon Glitch")
    @runtimeProperty("ModSettings.category.order", "9")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let weaponGlitchCount: Int32 = 4;

    // Cripple Movement (Technical Name: DisableCyberware)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Cripple Movement")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let crippleMovementRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Cripple Movement")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let crippleMovementCount: Int32 = 4;


    // ========================================================================
    // COVERT QUICKHACKS
    // ========================================================================

    // Visual Header for Covert Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- COVERT QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "11")
    @runtimeProperty("ModSettings.displayName", "Quickhacks in this group:")
    public let headerCovert: Bool = false;

    // Memory Wipe (Technical Name: MemoryWipe)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Memory Wipe")
    @runtimeProperty("ModSettings.category.order", "12")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let memoryWipeRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Memory Wipe")
    @runtimeProperty("ModSettings.category.order", "12")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let memoryWipeCount: Int32 = 4;

    // Sonic Shock (Technical Name: CommunicationCallIn)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Sonic Shock")
    @runtimeProperty("ModSettings.category.order", "13")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let sonicShockRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Sonic Shock")
    @runtimeProperty("ModSettings.category.order", "13")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let sonicShockCount: Int32 = 4;


    // ========================================================================
    // ULTIMATE QUICKHACKS
    // ========================================================================

    // Visual Header for Ultimate Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- ULTIMATE QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "14")
    @runtimeProperty("ModSettings.displayName", "Quickhacks in this group:")
    public let headerUltimate: Bool = false;

    // Suicide (Technical Name: Suicide)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Suicide")
    @runtimeProperty("ModSettings.category.order", "15")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let suicideRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Suicide")
    @runtimeProperty("ModSettings.category.order", "15")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let suicideCount: Int32 = 4;

    // Cyberpsychosis (Technical Name: Cyberpsychosis)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Cyberpsychosis")
    @runtimeProperty("ModSettings.category.order", "16")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let cyberpsychosisRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Cyberpsychosis")
    @runtimeProperty("ModSettings.category.order", "16")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let cyberpsychosisCount: Int32 = 4;

    // Detonate Grenade (Technical Name: DetonateGrenade)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Detonate Grenade")
    @runtimeProperty("ModSettings.category.order", "17")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let detonateGrenadeRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Detonate Grenade")
    @runtimeProperty("ModSettings.category.order", "17")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let detonateGrenadeCount: Int32 = 4;

    // System Collapse (Technical Name: SystemCollapse)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "System Collapse")
    @runtimeProperty("ModSettings.category.order", "18")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "5.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let systemCollapseRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "System Collapse")
    @runtimeProperty("ModSettings.category.order", "18")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "1") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let systemCollapseCount: Int32 = 4;

    // ========================================================================
    // HELPER & REGISTRATION
    // ========================================================================

    public static func Get(gi: GameInstance) -> ref<SpreaderSettings> {
        return GameInstance.GetScriptableSystemsContainer(gi).Get(n"UltimateSpreader.SpreaderSettings") as SpreaderSettings;
    }

    private func OnAttach() -> Void {
        ModSettings.RegisterListenerToClass(this);
        ModSettings.RegisterListenerToModifications(this);

        let configs = ModSettings.GetVars(n"Ultimate Spreader", n"Global Settings");
        for config in configs {
            config.SetVisible(!this.useIndividualSettings);
        }

        let quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- COMBAT QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
        quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- CONTROL QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
        quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- COVERT QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
        quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- ULTIMATE QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
    }

    public cb func OnModSettingsChange() {
        let configs = ModSettings.GetVars(n"Ultimate Spreader", n"Global Settings");
        for config in configs {
            config.SetVisible(!this.useIndividualSettings);
        }
    }
    
    private func OnDetach() -> Void {
        ModSettings.UnregisterListenerToClass(this);
        ModSettings.UnregisterListenerToModifications(this);
    }
}