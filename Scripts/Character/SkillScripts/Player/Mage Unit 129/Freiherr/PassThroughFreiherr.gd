extends Skill
class_name PassThroughFreiherr

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var newSteel = Steel.new()
    user.addEffect(newSteel, 3, 0)
