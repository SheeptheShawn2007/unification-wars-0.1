extends Node
class_name BattleManager

@onready var playerParty = $Parties/PlayerParty
@onready var enemyParty = $Parties/EnemyParty
@onready var turnQueue = $"../TurnQueue"
@onready var battleUI = $"../BattleUI"
@onready var dimOverlay: ColorRect = $"../BattleUI/DimOverlay"
@onready var highlightLayer: Node2D = $"../BattleUI/HighlightLayer"

enum GameState {
    WAITING,
    ACTING,
    DODGING,
    HITTING,
    ENDING
}

var enemyTurnEnd: bool = true
var actingCharacter: Character = null
var selectedSkill: Skill = null
var accRoll: int
var attackHit: bool
var validTargets: Array[Character]
var highlight: StyleBoxFlat = preload("res://Resources/Textures/SlotButtonHighlight.tres")
var normal: StyleBoxFlat = preload("res://Resources/Textures/SlotButtonNormal.tres")
var state: GameState = GameState.WAITING

func initBattle(players: Array[Character], enemies: Array[Character]):
    for i in players.size():
        players[i].rankPosition = i + 1
        playerParty.get_child(i).add_child(players[i])
        turnQueue.addCharacter(players[i])
        print("Player: ", players[i].name, " added to slot ", i + 1)
    
    for i in enemies.size():
        enemies[i].rankPosition = i + 1
        print(enemies[i].charName)
        enemyParty.get_child(i).add_child(enemies[i])
        turnQueue.addCharacter(enemies[i])
        print("Enemy: ", enemies[i].name, " added to slot ", i + 1)
    
    for slot in playerParty.get_children():
        slot.get_node("SlotButton").setHighlight(false)
    for slot in enemyParty.get_children():
        slot.get_node("SlotButton").setHighlight(false)
    
    startBattle()

func startBattle():
    for enemy in getPartyMembers(enemyParty):
        enemy.onBattleStart(self)
    for ally in getPartyMembers(playerParty):
        ally.onBattleStart(self)
    updateAllBars()
    processTurn()

func processTurn():
    state = GameState.WAITING
    print("processing turn")
    battleUI.selectingTarget = false
    battleUI.clearSkillMenu()
    if checkBattleEnd():
        return
    var acting = null
    while acting == null:
        turnQueue.tick()
        acting = turnQueue.getNextCharacter()
        
    if acting.state == Character.CharacterState.AT_ZERO_HP:
        acting.currHP = acting.recoverHP
        if acting.recoverHP > 0:
            acting.state = Character.CharacterState.ALIVE
        
    acting.onTurnStart(self)
    
    if isPlayerCharacter(acting):
        waitForPlayerInput(acting)
    else:
        executeEnemyAI(acting)

func isPlayerCharacter(character: Character) -> bool:
    return getPartyMembers(playerParty).has(character)

func waitForPlayerInput(character: Character):
    actingCharacter = character
    selectedSkill = null
    battleUI.showSkillButtons(character)
    battleUI.updateBars(character)

func onSkillSelected(skill: Skill):
    if not skill.selfPos.has(actingCharacter.rankPosition):
        return
    if skill.manaCost > actingCharacter.currMP:
        return
    selectedSkill = skill
    highlightValidTargets(skill)
    
func highlightValidTargets(skill: Skill):
    validTargets = []
    #print("Highlighting! x3")
    match skill.targetType:
        Skill.TargetType.SINGLE_ENEMY:
            #print("Single enemy rawr!")
            for enemy in getPartyMembers(enemyParty):
                if skill.tarPos.has(enemy.rankPosition) and skill.validTargetStates.has(enemy.state)\
                and (enemy.getEffectsType(Effect.EffectType.STEALTH) == [] or skill.ignoreStealth):
                    #print("Found one >:3c")
                    getSlotButton(enemy).setHighlight(true)
                    validTargets.append(enemy)
                    
        Skill.TargetType.SINGLE_ALLY:
            #print("Single ally :3c")
            for ally in getPartyMembers(playerParty):
                if skill.tarPos.has(ally.rankPosition) and skill.validTargetStates.has(ally.state)\
                and (ally.getEffectsType(Effect.EffectType.STEALTH) == [] or skill.ignoreStealth):
                    #print("Found one :3c")
                    getSlotButton(ally).setHighlight(true)
                    validTargets.append(ally)
                    
        Skill.TargetType.AOE_ENEMY:
            #print("AOE enemy >:3")
            for enemy in getPartyMembers(enemyParty):
                if skill.tarPos.has(enemy.rankPosition) and skill.validTargetStates.has(enemy.state)\
                and (enemy.getEffectsType(Effect.EffectType.STEALTH) == [] or skill.ignoreStealth):
                    #print("Found one >:3c")
                    getSlotButton(enemy).setHighlight(true)
                    validTargets.append(enemy)
                    
        Skill.TargetType.AOE_ALLY:
            #print("AOE ally :D")
            for ally in getPartyMembers(playerParty):
                if skill.tarPos.has(ally.rankPosition) and skill.validTargetStates.has(ally.state)\
                and (ally.getEffectsType(Effect.EffectType.STEALTH) == [] or skill.ignoreStealth):
                    #print("Found one :3c")
                    getSlotButton(ally).setHighlight(true)
                    validTargets.append(ally)
                    
        Skill.TargetType.SELF:
            #print("Self >:P")
            getSlotButton(actingCharacter).setHighlight(true)
            validTargets.append(actingCharacter)
            
    if validTargets.size() == 0:
        selectedSkill = null
        return
    battleUI.setValidTargets(validTargets)

func onTargetSelected(target: Character):
    if selectedSkill == null:
        battleUI.updateBars(target)
        return
    #print(target.name)
    match selectedSkill.targetType:
        Skill.TargetType.SINGLE_ENEMY, Skill.TargetType.SINGLE_ALLY:
            if not getSlotButton(target).highlighted:
                return
            executeSkill(actingCharacter, selectedSkill, target)
            
        Skill.TargetType.AOE_ENEMY, Skill.TargetType.AOE_ALLY:
            if not getSlotButton(target).highlighted:
                return
            executeSkill(actingCharacter, selectedSkill)
            
        Skill.TargetType.SELF:
            if not getSlotButton(target).highlighted:
                return
            executeSkill(actingCharacter, selectedSkill)

func onSlotSelected(slot: int, isEnemy: bool):
    var party = enemyParty if isEnemy else playerParty
    for character in getPartyMembers(party):
        if character.rankPosition == slot:
            onTargetSelected(character)

func resolveTargets(targets: Array) -> Array[Character]:
    var resolvedTargets: Array[Character] = []
    
    for target in targets:
        var guardEffects = target.getEffectsType(Effect.EffectType.GUARD)
        if guardEffects.size() > 0 and guardEffects[0].alignment == Effect.EffectAlignment.POSITIVE:
            var guardEffect = guardEffects[0]
            var guard = guardEffect.target
            if guard.state == Character.CharacterState.ALIVE and not targets.has(guard):
                if not resolvedTargets.has(guard):
                    resolvedTargets.append(guard)

            for effect in guardEffect.target.getEffectsType(Effect.EffectType.GUARD):
                effect.tick()
            guardEffect.tick()
            
        else:
            if not resolvedTargets.has(target):
                resolvedTargets.append(target)
    
    return resolvedTargets

func playAttackSequence(user: Character, results: Array) -> void:
    print("PAS: called with ", results.size(), " results")
    if results.is_empty():
        return

    var participants: Array[Character] = [user]
    for r in results:
        participants.append(r["target"])

    var dir := 1.0 if isPlayerCharacter(user) else -1.0

    print("PAS: before dim tween")
    var dimTween := create_tween()
    dimTween.tween_property(dimOverlay, "color:a", 0.75, 0.2)
    await dimTween.finished
    print("PAS: after dim tween")

    var proxies: Array[AnimatedSprite2D] = []
    var proxyHit: Array[bool] = []
    var spacing := 500.0 * dir
    var startX := -((participants.size() - 1) * spacing) / 2.0
    var restPositions: Array[Vector2] = []

    if is_instance_valid(user) and user.animatedSprite:
        var userProxy := user.animatedSprite.duplicate() as AnimatedSprite2D
        highlightLayer.add_child(userProxy)
        var userRest := Vector2(startX, 0)
        userProxy.position = userRest
        userProxy.scale *= 2.0
        proxies.append(userProxy)
        proxyHit.append(true)
        restPositions.append(userRest)
    else:
        print("PAS: WARNING user has no valid animatedSprite, proxy not created")

    for i in results.size():
        var t = results[i]["target"]
        if not is_instance_valid(t) or not t.animatedSprite:
            print("PAS: WARNING target ", i, " has no valid animatedSprite, skipped")
            continue
        var proxy := t.animatedSprite.duplicate() as AnimatedSprite2D
        highlightLayer.add_child(proxy)
        var restPos := Vector2(startX + (i + 1) * spacing, 0)
        proxy.position = restPos
        proxy.scale *= 2.0
        proxies.append(proxy)
        proxyHit.append(results[i]["hit"])
        restPositions.append(restPos)

    print("PAS: built ", proxies.size(), " proxies")

    if proxies.size() > 0:
        print("PAS: before lunge")
        var lunge := create_tween()
        lunge.tween_property(proxies[0], "position", restPositions[0] + Vector2(30, 0), 0.15)\
            .set_trans(Tween.TRANS_QUAD)
        await lunge.finished
        print("PAS: after lunge, before attack anim")

        await playAnimOrFallback(proxies[0], "attack")
        print("PAS: after attack anim")

        var recover := create_tween()
        recover.tween_property(proxies[0], "position", restPositions[0], 0.15)
        recover.play()

    for i in range(1, proxies.size()):
        var animName = "hit" if proxyHit[i] else "dodge"
        proxies[i].play(pickAnim(proxies[i], animName))
        var flinch := create_tween()
        if proxyHit[i]:
            flinch.tween_property(proxies[i], "position", restPositions[i] + Vector2(15, 0), 0.08)
            flinch.tween_property(proxies[i], "position", restPositions[i], 0.12)

    if proxies.size() > 1:
        print("PAS: before target hit/dodge anim")
        var lastAnim = "hit" if proxyHit[1] else "dodge"
        await playAnimOrFallback(proxies[1], lastAnim)
        print("PAS: after target hit/dodge anim")

    for proxy in proxies:
        proxy.queue_free()
    print("PAS: before undim")
    var undimTween := create_tween()
    undimTween.tween_property(dimOverlay, "color:a", 0.0, 0.2)
    await undimTween.finished
    print("PAS: done")

func pickAnim(sprite: AnimatedSprite2D, animName: String) -> String:
    if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation(animName):
        return animName
    return "Idle"

func playAnimOrFallback(sprite: AnimatedSprite2D, animName: String) -> void:
    if sprite == null or not is_instance_valid(sprite) or sprite.sprite_frames == null:
        print("PAF: sprite invalid, returning early")
        return
    var resolvedName := pickAnim(sprite, animName)
    sprite.play(resolvedName)
    var fps = sprite.sprite_frames.get_animation_speed(resolvedName)
    print("PAF: playing '", resolvedName, "' fps=", fps, " loop=", sprite.sprite_frames.get_animation_loop(resolvedName))
    if fps <= 0.0 or sprite.sprite_frames.get_animation_loop(resolvedName):
        await get_tree().create_timer(0.3).timeout
        print("PAF: timer fallback done")
    else:
        await sprite.animation_finished
        print("PAF: animation_finished signal received")

func executeSkill(user: Character, skill: Skill, target: Character = null):
    state = GameState.ACTING
    var targets: Array[Character] = []
    var newTarget: Character = null
    var checkVal: int = 0
    var isPlayer = isPlayerCharacter(user)
    var friendlyParty = playerParty if isPlayer else enemyParty
    var hostileParty = enemyParty if isPlayer else playerParty
    var accVal: int = 0
    var dodgeVal: int = 0
    var attackResults: Array = []
    user.currMP -= skill.manaCost
    state = GameState.DODGING
    match skill.targetType:
        Skill.TargetType.SINGLE_ENEMY:
            targets = [target]
            newTarget = resolveTargets(targets)[0]
            skill.onUse(user, newTarget, self)
            accRoll = randi_range(1,100)
            for effect in target.getEffectsType(Effect.EffectType.DODGE):
                dodgeVal += effect.apply(user, target, self)
            for effect in user.getEffectsType(Effect.EffectType.ACCURACY):
                accVal += effect.apply(user, target, self)
            if accRoll <= max(1, user.accuracy + skill.accuracyBonus + accVal) - \
            max(0, target.dodge+dodgeVal) * int(!skill.ignoreDodge):
                dealDamage(user, newTarget, skill)
                user.onDamageDealt(newTarget, self)
                newTarget.onHit(user, self)
                skill.onHit(user, newTarget, self)
                checkVal = checkCharacterState(newTarget)
                attackResults.append({"target": newTarget, "hit": true})
            else:
                attackResults.append({"target": newTarget, "hit": false})
            skill.afterUse(user, newTarget, self)
            if checkVal == 1:
                user.onDown(newTarget, self)
                skill.onDown(user, newTarget, self)
            elif checkVal == 2:
                user.onKill(self)
                skill.onKill(user, self)

        Skill.TargetType.SINGLE_ALLY:
            skill.onUse(user, target, self)
            dealDamage(user, target, skill)
            skill.onHit(user, target, self)
            skill.afterUse(user, target, self)
            checkVal = checkCharacterState(target) #FIX
            attackResults.append({"target": target, "hit": true})
            if checkVal == 1:
                user.onDown(target, self)
                skill.onDown(user, target, self)
            elif checkVal == 2:
                user.onKill(self)
                skill.onKill(user, self)

        Skill.TargetType.AOE_ENEMY:
            for enemy in getPartyMembers(hostileParty):
                if skill.tarPos.has(enemy.rankPosition):
                    targets.append(enemy)
            targets = resolveTargets(targets)
            skill.onUse(user, null, self)
            for t in targets:
                checkVal = 0
                accRoll = randi_range(1,100)
                dodgeVal = 0
                accVal = 0
                for effect in t.getEffectsType(Effect.EffectType.DODGE):
                    dodgeVal += effect.apply(user, t, self)
                for effect in user.getEffectsType(Effect.EffectType.ACCURACY):
                    accVal += effect.apply(user, t, self)
                if accRoll <= max(1, user.accuracy + skill.accuracyBonus + accVal) - \
                max(0, t.dodge+dodgeVal) * int(!skill.ignoreDodge):
                    dealDamage(user, t, skill)
                    user.onDamageDealt(t, self)
                    t.onHit(user, self)
                    skill.onHit(user, t, self)
                    checkVal = checkCharacterState(t)
                    attackResults.append({"target": t, "hit": true})
                else:
                    attackResults.append({"target": t, "hit": false})
                if checkVal == 1:
                    user.onDown(t, self)
                    skill.onDown(user, t, self)
                elif checkVal == 2:
                    user.onKill(self)
                    skill.onKill(user, self)
            skill.afterUse(user, null, self)

        Skill.TargetType.AOE_ALLY:
            skill.onUse(user, null, self)
            for ally in getPartyMembers(friendlyParty):
                if skill.tarPos.has(ally.rankPosition):
                    dealDamage(user, ally, skill)
                    skill.onHit(user, ally, self)
                    checkVal = checkCharacterState(ally) #FIX
                    attackResults.append({"target": ally, "hit": true})
                    if checkVal == 1:
                        user.onDown(ally, self)
                        skill.onDown(user, ally, self)
                    elif checkVal == 2:
                        user.onKill(self)
                        skill.onKill(user, self)
            skill.afterUse(user, null, self)

        Skill.TargetType.SELF:
            skill.onUse(user, user, self)
            skill.onHit(user, user, self)
            skill.afterUse(user, user, self)
            checkVal = checkCharacterState(user)
            attackResults.append({"target": user, "hit": true})
            if checkVal == 1:
                user.onDown(user, self)
                skill.onDown(user, null, self)
            elif checkVal == 2:
                user.onKill(self)
                skill.onKill(user, self)

    await playAttackSequence(user, attackResults)

    state = GameState.ENDING
    turnQueue.resetTimer(user, skill.timeCost, self)
    user.onTurnEnd(self)
    clearHighlights()
    updateAllBars()
    if checkBattleEnd():
        return
        #end battle
    if isPlayer:
        processTurn()
        
func dealDamage(user: Character, target: Character, skill: Skill):
    state = GameState.HITTING
    var offenseVal: int = 0
    if not skill.ignoreOffense:
        for effect in user.getEffectsType(Effect.EffectType.DAMAGE):
            offenseVal += effect.apply(user, target, self)
    
    var defenseVal: int = 0
    if not skill.ignoreDefense:
        for effect in target.getEffectsType(Effect.EffectType.DEFENSE):
            defenseVal += effect.apply(target, user, self)
    
    var damage: int
    var damageVarRes: int
    var effectiveDefense = max(0,
    (target.defense - skill.pierce
    + defenseVal)) - offenseVal
    if skill.damage > 0:
        damageVarRes = randi_range(0, skill.damageVar)
        damage = max(1, skill.damage + damageVarRes - effectiveDefense)
        target.currHP -= damage
        print(target.charName + " got " + str(damage) + " damage from " +\
        user.charName)
        print("Var damage result was " + str(damageVarRes))
    elif skill.damage <= 0:
        damageVarRes = randi_range(0, skill.damageVar)
        damage = min(0, skill.damage + damageVarRes - offenseVal)
        target.currHP = min(target.maxHP, target.currHP - damage)
        #print(target.charName + " got " + str(-damage) + " healing from " +\
        #user.charName)
        #print("Var damage result was " + str(damageVarRes))

func checkCharacterState(character: Character) -> int:
    var kill = 0
    if character.state == Character.CharacterState.AT_ZERO_HP:
        character.injuries += 1
    elif character.currHP <= 0:
        character.injuries += 1
        kill = 1
        character.state = Character.CharacterState.AT_ZERO_HP
    if character.injuries > character.resilience:
        character.state = Character.CharacterState.CORPSE
        turnQueue.removeCharacter(character)
        kill = 2
        if character.friendly:
            for enemy in getPartyMembers(enemyParty):
                if enemy.state != Character.CharacterState.INCAPACITATED and\
                enemy.state != Character.CharacterState.CORPSE:
                    enemy.onEnemyDeath(self)
            for ally in getPartyMembers(playerParty):
                if ally.state != Character.CharacterState.INCAPACITATED and\
                ally.state != Character.CharacterState.CORPSE:
                    ally.onAllyDeath(self)
        else:
            for enemy in getPartyMembers(enemyParty):
                if enemy.state != Character.CharacterState.INCAPACITATED and\
                enemy.state != Character.CharacterState.CORPSE:
                    enemy.onAllyDeath(self)
            for ally in getPartyMembers(playerParty):
                if ally.state != Character.CharacterState.INCAPACITATED and\
                ally.state != Character.CharacterState.CORPSE:
                    ally.onEnemyDeath(self)            
        if character.spawnCorpse:
            character.currHP = character.maxCorpseHP
        else:
            print("killing character!!!")
            if character.friendly:
                moveCharacter(playerParty, character, 4)
            else:
                moveCharacter(enemyParty, character, 4)
            character.get_parent().remove_child(character)
            character.queue_free()
            
    return kill

func clearHighlights():
    validTargets = []
    for slot in playerParty.get_children():
        slot.get_node("SlotButton").setHighlight(false)
    for slot in enemyParty.get_children():
        slot.get_node("SlotButton").setHighlight(false)

func executeEnemyAI(character: Character):
    character.runAI(self)

func moveCharacter(party: Node, character: Character, newPosition: int):
    print("moving character")
    var members = getPartyMembers(party)
    members.sort_custom(func(a,b): return a.rankPosition < b.rankPosition)
    
    var oldPosition = character.rankPosition
    newPosition = clamp(newPosition, 1, members.size())
    character.rankPosition = newPosition
    print(newPosition)
    
    if newPosition == oldPosition:
        return
        
    if newPosition < oldPosition:
        for member in members:
            if member == character:
                continue
            if member.rankPosition >= newPosition and member.rankPosition < \
            oldPosition:
                member.rankPosition += 1
    else:
        for member in members: 
            if member == character:
                continue
            if member.rankPosition <= newPosition and member.rankPosition > \
            oldPosition:
                member.rankPosition -= 1
    
    members.sort_custom(func(a,b): return a.rankPosition < b.rankPosition)
    var slots = party.get_children()
    for i in range(members.size()):
        var member = members[i]
        var targetSlot = slots[i]
        if member.get_parent() != targetSlot:
            member.get_parent().remove_child(member)
            targetSlot.add_child(member)
    updateAllBars()

func getPartyMembers(party: Node) -> Array[Character]:
    var members: Array[Character] = []
    for slot in party.get_children():
        for child in slot.get_children():
            if child is Character:
                members.append(child)
    return members
 
func checkBattleEnd() -> bool:
    var playersAlive = getPartyMembers(playerParty).any(func(c): 
        return c.state == Character.CharacterState.ALIVE or\
        c.state == Character.CharacterState.AT_ZERO_HP)
    var enemiesAlive = getPartyMembers(enemyParty).any(func(c): 
        return c.state == Character.CharacterState.ALIVE or\
        c.state == Character.CharacterState.AT_ZERO_HP)
    
    if not playersAlive:
        return true
    if not enemiesAlive:
        return true
    return false

func getSlotButton(character: Character) -> Button:
    var party = playerParty if isPlayerCharacter(character) else enemyParty
    for slot in party.get_children():
        for child in slot.get_children():
            if child is Character and child == character:
                return slot.get_node("SlotButton")
    return null

func getSlotPanel(character: Character) -> VBoxContainer:
    var party = playerParty if isPlayerCharacter(character) else enemyParty
    for slot in party.get_children():
        for child in slot.get_children():
            if child is Character and child == character:
                return slot.get_node("VboxContainer")
    return null

func updateAllBars():
    for slot in playerParty.get_children():
        slot.get_node("VboxContainer").updateBars()
    for slot in enemyParty.get_children():
        slot.get_node("VboxContainer").updateBars()
