extends Character
class_name Enemy

var patternIndex: int = 0

func _ready():
    super()
    friendly = false

func runAI(battleManager: BattleManager):
    return null
    
func getValidTargets(skill: Skill, battleManager: BattleManager) -> Array[Character]:
    var candidates: Array[Character] = []
    
    match skill.targetType:
        Skill.TargetType.SINGLE_ENEMY, Skill.TargetType.AOE_ENEMY:
            candidates = battleManager.getPartyMembers(battleManager.playerParty)
        Skill.TargetType.SINGLE_ALLY, Skill.TargetType.AOE_ALLY:
            candidates = battleManager.getPartyMembers(battleManager.enemyParty)
        Skill.TargetType.SELF:
            return [self]
    
    return candidates.filter(func(c):
        return skill.tarPos.has(c.rankPosition) and \
        skill.validTargetStates.has(c.state))

func pickTarget(skill: Skill, battleManager: BattleManager) -> Character:
    var valid = getValidTargets(skill, battleManager)
    if valid.is_empty():
        return null
    return targetPriority(valid)

func trySkill(skill: Skill, battleManager: BattleManager) -> bool:
    var target = pickTarget(skill, battleManager)
    if target != null:            
        return true
    return false

func targetPriority(characters: Array[Character]):
    return null

func endTurn(battleManager: BattleManager):
    battleManager.processTurn()
