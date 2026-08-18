extends Skill
class_name TalesFromtheBottle

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var newTales = TalesFreiherr.new()
    target.addEffect(newTales, 3, 0)
