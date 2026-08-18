extends Skill
class_name LungeFreiherr

var baseDamage: int
func _onready():
    baseDamage = damage

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var currSteel = user.hasEffect("Steel")
    if !currSteel == null:
        damage += currSteel.count
    user.removeEffect(currSteel)
    battleManager.moveCharacter(battleManager.playerParty, user, user.rankPosition - 1)

func afterUse(user: Character, target: Character, battleManager: BattleManager):
    damage = baseDamage
