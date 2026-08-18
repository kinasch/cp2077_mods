// Empty logging message, because I always forget it
//LogChannel(n"DEBUG", s"[Ultimate Spreader] Text \(variable).");

// Added field to identify modded spread clones and skip RAM costs
@addField(BaseScriptableAction)
public let m_UltimateSpreaderCloneFlag: Bool;

@wrapMethod(BaseScriptableAction)
public func CanPayCost(opt instigator: ref<GameObject>, opt skipCostCheck: Bool) -> Bool {
    if this.m_UltimateSpreaderCloneFlag {
        return true; 
    }
    return wrappedMethod(instigator, skipCostCheck);
}

@wrapMethod(BaseScriptableAction)
public func PayCost(opt checkForOverclockedState: Bool) -> Bool {
    if this.m_UltimateSpreaderCloneFlag {
        return true; 
    }
    return wrappedMethod(checkForOverclockedState);
}

// New event, needed to execute a delayed event
public class UltimateSpreaderEvent extends Event {
    public let ownerID: EntityID;
    public let actionID: TweakDBID;
}

@wrapMethod(BaseScriptableAction)
protected func ProcessRPGAction(gameInstance: GameInstance, opt gameplayRoleComponent: ref<GameplayRoleComponent>) -> Void {
    
    // Execute the base hack first
    wrappedMethod(gameInstance, gameplayRoleComponent);

    // Downcast
    let puppetAction = this as PuppetAction;

    // TODO: Check for quickhacks that should not spread, e.g. Ping (does not need to spread)
    
    // Isolate quickhacks and check for spread disabling flags
    if !IsDefined(puppetAction) || puppetAction.m_disableSpread || puppetAction.m_UltimateSpreaderCloneFlag || !puppetAction.IsQuickHack() { 
        return;
    }

    let requesterID: EntityID = puppetAction.GetRequesterID();
    let target = gameplayRoleComponent.GetOwner() as NPCPuppet; //GameInstance.FindEntityByID(gameInstance, requesterID) as NPCPuppet;
    let owner = puppetAction.GetExecutor() as PlayerPuppet; 
    
    if !IsDefined(target) || !IsDefined(owner) { return; }

    // Using hardcoded values for testing.
    // TODO: Change
    let spreadRadius: Float = 30.0; 
    let maxTargets: Int32 = 3;

    // Target acquisition by scanning around the player and then filtering by checking distance to target (spreadRadius)
    // High resource cost, was never an issue during testing though
    // Using the GetNPCsAroundObject function on the target did not work here for me
    let playerSearchRadius: Float = 250.0; 
    let allNearbyNPCs = owner.GetNPCsAroundObject(playerSearchRadius);
    let targetPos = target.GetWorldPosition();
    let actionId: TweakDBID = puppetAction.GetObjectActionRecord().GetID();
    let validTargets: array<ref<NPCPuppet>>;
    
    let j = 0;
    while j < ArraySize(allNearbyNPCs) {
        let potentialTarget = allNearbyNPCs[j];
        if IsDefined(potentialTarget) && potentialTarget != target && potentialTarget.IsEnemy() && potentialTarget.IsActive() {
            if Vector4.Distance(potentialTarget.GetWorldPosition(), targetPos) <= spreadRadius {
                ArrayPush(validTargets, potentialTarget);
            }
        }
        j += 1;
    }

    let targetsFromTarget: array<ref<NPCPuppet>>;
    let squadMemberInterface = target.GetSquadMemberComponent();
    let squadMembers: array<wref<Entity>>;
    if IsDefined(squadMemberInterface) {
        AISquadHelper.GetSquadmates(target, squadMembers, false);

        let k = 0;
        while k < ArraySize(squadMembers) {
            // Directly downcast the wref reference to NPCPuppet
            let member = squadMembers[k] as NPCPuppet;
            
            if IsDefined(member) && member != target && member.IsActive() {
                if Vector4.Distance(member.GetWorldPosition(), targetPos) <= spreadRadius {
                    ArrayPush(targetsFromTarget, member);
                }
            }
            k += 1;
        }
    }
    //LogChannel(n"DEBUG", s"[Ultimate Spreader] \(ArraySize(targetsFromTarget)) targets from target squad with \(ArraySize(squadMembers)) members.");

    validTargets = targetsFromTarget;

    
    // Get upload time to spread after time finishes.
    let primaryUploadTime: Float = puppetAction.GetActivationTime(); 
    
    let i = 0;
    let spreadCount = 0;

    while i < ArraySize(validTargets) {
        if spreadCount >= maxTargets { break; }
        
        let newTarget = validTargets[i];

        // Using another variable to improve readibility and include possible changes (like stagered spreading or additional jumps)
        let sequenceDelay: Float = primaryUploadTime;

        let spreadEvt = new UltimateSpreaderEvent();
        spreadEvt.ownerID = owner.GetEntityID();
        spreadEvt.actionID = actionId;

        // Dispatch event to pipeline - maybe create a variable for the delay system and not use the getter every time...
        GameInstance.GetDelaySystem(newTarget.GetGame()).DelayEvent(newTarget, spreadEvt, sequenceDelay);
        
        // Not really checking for any success here, could just use on of either spreadCount or i
        // Left in, in case a success check is added back
        spreadCount += 1;
        i += 1;
    }
}

@addMethod(ScriptedPuppet)
protected cb func OnUltimateSpreaderEvent(evt: ref<UltimateSpreaderEvent>) -> Bool {
    // Abort if the enemy died while waiting for their turn in the chain reaction. No idea how the base game handles this ...
    if !this.IsActive() { return false; }

    // TODO: add owner as GameObject to the Event
    let owner = GameInstance.FindEntityByID(this.GetGame(), evt.ownerID) as GameObject;
    if !IsDefined(owner) { return false; }

    let gameplayRoleComponent = this.GetGameplayRoleComponent();
    
    // Construct the clone hack
    let spreadAction = new PuppetAction();
    spreadAction.RegisterAsRequester(this.GetEntityID());
    spreadAction.SetExecutor(owner);
    spreadAction.SetObjectActionID(evt.actionID);
    spreadAction.SetUp(this.GetPuppetPS());
    
    // Vanilla, mark to prevent more spread than configured
    spreadAction.SetDisableSpread(true); 
    // Flag the action to skip the RAM costs.
    spreadAction.m_UltimateSpreaderCloneFlag = true;
    
    spreadAction.ProcessRPGAction(this.GetGame(), gameplayRoleComponent);
    
    // Draw upload bars with the used quickhack's icon
    if IsDefined(spreadAction.GetInteractionIcon()) && IsDefined(gameplayRoleComponent) {
        let visualData = new GameplayRoleMappinData();
        visualData.statPoolType = gamedataStatPoolType.QuickHackUpload;
        visualData.m_duration = spreadAction.GetActivationTime(); 
        visualData.m_textureID = spreadAction.GetInteractionIcon().TexturePartID().GetID();
        visualData.m_visibleThroughWalls = true;
        gameplayRoleComponent.ToggleMappin(gamedataMappinVariant.QuickHackVariant, true, true, visualData);
    }

    return true;
}