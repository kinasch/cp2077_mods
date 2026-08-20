module UltimateSpreader

// Using localized text only for the quickhacks here and even this is overkill imo

@if(!ModuleExists("OpCyberdeckMod") && ModuleExists("ModSettingsModule"))
public class SpreaderSettings extends ScriptableSystem {
    
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.displayName", "Use Individual Settings")
    @runtimeProperty("ModSettings.description", "Display and use settings for every hack individually.")
    public let useIndividualSettings: Bool = false;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.displayName", "Use Staggered Spread")
    @runtimeProperty("ModSettings.description", "Next spread starts uploading after prior spread finished (hack spreads one by one).")
    public let useStaggeredSpread: Bool = false;

    // Add config for things like "only with cyberdeck stat"

    // ========================================================================
    // Global spread settings
    // ========================================================================

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Global Settings")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Global Spread Distance")
    @runtimeProperty("ModSettings.description", "Default radius if Individual Settings are OFF.")
    @runtimeProperty("ModSettings.step", "1.0")
    @runtimeProperty("ModSettings.min", "1.0")
    @runtimeProperty("ModSettings.max", "100.0")
    public let globalSpreadRadius: Float = 8.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Global Settings")
    @runtimeProperty("ModSettings.category.order", "1")
    @runtimeProperty("ModSettings.displayName", "Global Spread Count")
    @runtimeProperty("ModSettings.description", "Default max targets if Individual Settings are OFF.")
    @runtimeProperty("ModSettings.step", "1")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "15")
    public let globalMaxTargets: Int32 = 0;


    // ========================================================================
    // Combat Quickhacks
    // ========================================================================

    // Visual Header for Combat Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- COMBAT QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "2")
    @runtimeProperty("ModSettings.displayName", "")
    private let headerCombat: Bool = false;

    // Short Circuit (Technical Name: Overload)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-EMPOverloadProgram")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let shortCircuitRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-EMPOverloadProgram")
    @runtimeProperty("ModSettings.category.order", "3")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let shortCircuitCount: Int32 = 0;

    // Overheat (Technical Name: Overheat)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-OverheatProgram")
    @runtimeProperty("ModSettings.category.order", "4")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let overheatRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-OverheatProgram")
    @runtimeProperty("ModSettings.category.order", "4")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let overheatCount: Int32 = 0;

    // Contagion (Technical Name: Contagion)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-ContagionProgram")
    @runtimeProperty("ModSettings.category.order", "5")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let contagionRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-ContagionProgram")
    @runtimeProperty("ModSettings.category.order", "5")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let contagionCount: Int32 = 0;

    // Synapse Burnout (Technical Name: BrainMelt)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-BrainMeltProgram")
    @runtimeProperty("ModSettings.category.order", "6")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let synapseBurnoutRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-BrainMeltProgram")
    @runtimeProperty("ModSettings.category.order", "6")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let synapseBurnoutCount: Int32 = 0;


    // ========================================================================
    // Control Quickhacks
    // ========================================================================

    // Visual Header for Control Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- CONTROL QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "7")
    @runtimeProperty("ModSettings.displayName", "")
    public let headerControl: Bool = false;

    // Reboot Optics (Technical Name: Blind)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Names-BlindProgram")
    @runtimeProperty("ModSettings.category.order", "8")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let rebootOpticsRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Names-BlindProgram")
    @runtimeProperty("ModSettings.category.order", "8")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let rebootOpticsCount: Int32 = 0;

    // Weapon Glitch (Technical Name: WeaponMalfunction)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-JamWeaponProgram")
    @runtimeProperty("ModSettings.category.order", "9")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let weaponGlitchRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-JamWeaponProgram")
    @runtimeProperty("ModSettings.category.order", "9")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let weaponGlitchCount: Int32 = 0;

    // Cripple Movement (Technical Name: LocomotionMalfunction)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-LocomotionMalfunctionProgram")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let crippleMovementRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-LocomotionMalfunctionProgram")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let crippleMovementCount: Int32 = 0;

    // Cyberware Malfunction (Technical Name: CyberwareMalfunction)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-CyberwareMalfunction")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let cyberwareMalfunctionRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-CyberwareMalfunction")
    @runtimeProperty("ModSettings.category.order", "10")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let cyberwareMalfunctionCount: Int32 = 0;


    // ========================================================================
    // Covert Quickhacks
    // ========================================================================

    // Visual Header for Covert Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- COVERT QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "11")
    @runtimeProperty("ModSettings.displayName", "")
    public let headerCovert: Bool = false;

    // Memory Wipe (Technical Name: MemoryWipe)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-MemoryWipeProgram")
    @runtimeProperty("ModSettings.category.order", "12")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let memoryWipeRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-MemoryWipeProgram")
    @runtimeProperty("ModSettings.category.order", "12")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let memoryWipeCount: Int32 = 0;


    // ========================================================================
    // Ultimate Quickhacks
    // ========================================================================

    // Visual Header for Ultimate Quickhacks
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "--- ULTIMATE QUICKHACKS ---")
    @runtimeProperty("ModSettings.category.order", "14")
    @runtimeProperty("ModSettings.displayName", "")
    public let headerUltimate: Bool = false;

    // Suicide (Technical Name: Suicide)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Names-SuicideProgram")
    @runtimeProperty("ModSettings.category.order", "15")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let suicideRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Names-SuicideProgram")
    @runtimeProperty("ModSettings.category.order", "15")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let suicideCount: Int32 = 0;

    // Cyberpsychosis (Technical Name: Madness)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-MadnessProgram")
    @runtimeProperty("ModSettings.category.order", "16")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let cyberpsychosisRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-MadnessProgram")
    @runtimeProperty("ModSettings.category.order", "16")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let cyberpsychosisCount: Int32 = 0;

    // Detonate Grenade (Technical Name: Grenade)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Names-GrenadeExplodeProgram")
    @runtimeProperty("ModSettings.category.order", "17")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let detonateGrenadeRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-RPG-Items-Names-GrenadeExplodeProgram")
    @runtimeProperty("ModSettings.category.order", "17")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let detonateGrenadeCount: Int32 = 0;

    // System Collapse (Technical Name: SystemCollapse)
    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-SystemCollapseProgram")
    @runtimeProperty("ModSettings.category.order", "18")
    @runtimeProperty("ModSettings.displayName", "Spread Distance")
    @runtimeProperty("ModSettings.step", "1.0") @runtimeProperty("ModSettings.min", "1.0") @runtimeProperty("ModSettings.max", "100.0")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let systemCollapseRadius: Float = 30.0;

    @runtimeProperty("ModSettings.mod", "Ultimate Spreader")
    @runtimeProperty("ModSettings.category", "Gameplay-Parts-Programs-DisplayName-SystemCollapseProgram")
    @runtimeProperty("ModSettings.category.order", "18")
    @runtimeProperty("ModSettings.displayName", "Spread Count")
    @runtimeProperty("ModSettings.step", "1") @runtimeProperty("ModSettings.min", "0") @runtimeProperty("ModSettings.max", "15")
    @runtimeProperty("ModSettings.dependency", "useIndividualSettings")
    public let systemCollapseCount: Int32 = 0;

    // Registration and helper functions
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

        // Hide the bools in the quickhack category mod settings categories
        let quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- COMBAT QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
        // Use SetEnabled(false) to forbid editing
        quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- CONTROL QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
        quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- COVERT QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
        quickhackCategoryConfig = ModSettings.GetVars(n"Ultimate Spreader", n"--- ULTIMATE QUICKHACKS ---");
        quickhackCategoryConfig[0].SetVisible(false);
    }

    // Check for the individual settings button to hide global settings
    // Might create a bit of a lag when lots of Mod Settings mods are hooked on this - no idea
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