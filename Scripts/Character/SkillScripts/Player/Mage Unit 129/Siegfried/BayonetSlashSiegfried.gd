extends Skill
class_name BayonetSlash

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var newSteel = Steel.new()
    user.addEffect(newSteel, 2, 0)
