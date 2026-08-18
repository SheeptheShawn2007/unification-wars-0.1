extends Skill
class_name WedgeAndStinger

var baseDamage: int = damage

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var currSteel = user.hasEffect("Steel")
    if currSteel != null:
        damage += currSteel.count
    user.removeEffect(currSteel)

func afterUse(user: Character, target: Character, battleManager: BattleManager):
    damage = baseDamage
