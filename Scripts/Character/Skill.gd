extends Resource
class_name Skill

enum TargetType {
    SINGLE_ENEMY,
    SINGLE_ALLY,
    AOE_ENEMY,
    AOE_ALLY,
    SELF
}

@export var validTargetStates: Array[Character.CharacterState]
@export var targetType: TargetType
@export var skillName: String
@export var damage: int = 0
@export var damageVar: int = 0
@export var selfPos: Array[int]
@export var tarPos: Array[int]
@export var timeCost: int
@export var stunTime: int
@export var pierce: int
@export var manaCost: int
@export var accuracyBonus: int
@export var ignoreGuard: bool
@export var ignoreDodge: bool 
@export var ignoreDefense: bool 
@export var ignoreStealth: bool 
@export var ignoreOffense: bool 

func onUse(user: Character, target: Character, battleManager: BattleManager):
    pass

func onHit(user: Character, target: Character, battleManager: BattleManager):
    pass
    
func onDown(user: Character, target: Character, battleManager:BattleManager):
    pass
    
func onKill(user: Character, battleManager: BattleManager):
    pass

func afterUse(user: Character, target: Character, battleManager: BattleManager):
    pass
