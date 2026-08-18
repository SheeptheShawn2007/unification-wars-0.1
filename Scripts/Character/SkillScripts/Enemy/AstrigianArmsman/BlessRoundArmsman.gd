extends Skill
class_name BlessRoundArmsman

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var newBless = BlessedAmmo.new()
    user.addEffect(newBless, 1, 0)
