extends Skill
class_name NobleTechnique

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var dodge = NobleTechniqueEffect.new()
    target.addEffect(dodge, 1, 1)
