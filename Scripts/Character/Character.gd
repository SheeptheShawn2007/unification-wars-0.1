extends Node2D
class_name Character

enum Keywords {
    LATICIAN,
    SONTIAN,
    KANTIGAN,
    CATATIAN,
    ASTRIGIAN,
    CVIJERAN,
    MYNERTIAN,
    IZCAEAN,
    KIZENESE,
    XHOCHEAN,
    FIJCAEN,
    CRESTICAN,
    OUTLANDER,
    BARBARIAN,
    MAGE,
    ANTIMAGE,
    SOLDIER,
    STEEL,
    AMMO,
    BLEED,
    BURN,
    POISON,
    CHARGE,
    UNIT129,
    UNIT130
}

@export var maxHP: int
var currHP: int
@export var maxMP: int
var currMP: int
@export var originalDefense: int
@export var rankPosition: int
@export var resilience: int
@export var MaxCorpseHP: int
@export var corpseDefense: int
@export var recoverHP: int
@export var originalSpeed: int
@export var manaRegen: int
@export var manaExhaust: int
@export var manaBonus: int
@export var hpRegen: int
@export var shield: int
@export var originalDodge: int
@export var originalAccuracy: int
@export var spawnCorpse: bool
@export var passSkill: Skill
@export var charName: String
var highlight: bool = false
var friendly: bool = true


var effects: Dictionary = {}
@export var skills: Array[Skill]
@export var keywords: Array[Keywords]

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

enum CharacterState {
    ALIVE,
    AT_ZERO_HP,
    INCAPACITATED,
    CORPSE
}

var state: CharacterState = CharacterState.ALIVE
var injuries: int = 0
var currentCorpseHP: int = 0
var speed: int
var defense: int
var accuracy: int
var dodge: int

func _ready():
    speed = originalSpeed
    defense = originalDefense
    accuracy = originalAccuracy
    dodge = originalDodge
    currHP = maxHP
    currMP = maxMP
    for type in Effect.EffectType.values():
        effects[type] = []

func tick(battleManager: BattleManager):
    speed = originalSpeed
    defense = originalDefense
    accuracy = originalAccuracy
    dodge = originalDodge
    for effect in self.getEffectsType(Effect.EffectType.DODGE):
        effect.apply(self, null, battleManager)
    for effect in self.getEffectsType(Effect.EffectType.DEFENSE):
        effect.apply(self, null, battleManager)
    for effect in self.getEffectsType(Effect.EffectType.ACCURACY):
        effect.apply(self, null, battleManager)
    for effect in self.getEffectsType(Effect.EffectType.SPEED):
        speed += effect.apply(self, null, battleManager)
    for effect in self.getEffectsType(Effect.EffectType.MISCTURNEND):
        effect.apply(self, null, battleManager)
    var healedAmt = min(maxHP - currHP, min(hpRegen, currMP))
    currHP += healedAmt
    currMP -= healedAmt
    #print("Healed " + str(healedamt))
    if currMP <= manaExhaust:
        currMP += manaBonus
        pass #GIVE SELF MANA EXHAUST
    currMP += manaRegen
    currMP = min(currMP, maxMP)

func getEffectsType(type: Effect.EffectType) -> Array:
    return effects[type]

func getEffectsAlign(align: Effect.EffectAlignment) -> Array:
    var result = []
    for type in effects:
        for effect in effects[type]:
            if effect.alignment == align:
                result.append(effect)
    return result

func setHighlight(val: bool):
    highlight = val
    
func onBattleStart(battleManager: BattleManager):
    pass
    
func onTurnStart(battleManager: BattleManager):
    pass

func onTurnEnd(battleManager: BattleManager):
    pass

func onHit(target: Character, battleManager: BattleManager):
    pass

func onDamageDealt(target: Character, battleManager: BattleManager):
    pass

func onAllyDeath(battleManager: BattleManager):
    pass

func onKill(battleManager: BattleManager):
    pass
    
func onDown(target: Character, battleManager:BattleManager):
    pass

func onEnemyDeath(battleManager: BattleManager):
    pass

func addEffect(effect: Effect, count: int, potency: int):
    var found = false
    
    for type in effects:
        for existing in effects[type]:
            if existing.get_script() == effect.get_script():
                existing.potency += potency
                existing.count += count
                found = true
                break
        if found:
            break
    
    if not found:
        var newEffect = effect.duplicate()
        newEffect.potency = max(1, potency)
        newEffect.count = max(1, count)
        for type in effect.effectType:
            effects[type].append(newEffect)

func removeEffect(effect: Effect) -> void:
    for type in effect.effectType:
        effects[type].erase(effect)

func hasEffect(name: String) -> Effect:
    for type in effects:
        for effect in effects[type]:
            if effect.effectName == name:
                return effect
    return null
