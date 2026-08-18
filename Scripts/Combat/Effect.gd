extends Resource
class_name Effect

enum EffectType {
    DEFENSE,
    DOT,
    ACCURACY,
    DODGE,
    CHARGE,
    SPEED,
    DAMAGE,
    GUARD,
    STEALTH,
    CRIT,
    MISCTURNEND
}

enum EffectAlignment {
    NEGATIVE,
    NEUTRAL,
    POSITIVE
}

@export var effectType: Array[EffectType]
@export var alignment: EffectAlignment

@export var count: int
@export var potency: int
@export var showCount = true
@export var showPotency = true
@export var precedence: int
@export var effectName: String
var target: Character

func apply(user: Character, target: Character, battleManager: BattleManager): 
    pass
