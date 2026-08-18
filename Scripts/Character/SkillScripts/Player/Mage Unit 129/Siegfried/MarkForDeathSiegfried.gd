extends Skill
class_name MarkForDeath

func onHit(user: Character, target: Character, battleManager:BattleManager):
    var newMark = Mark.new()
    target.addEffect(newMark, 3, 0)
