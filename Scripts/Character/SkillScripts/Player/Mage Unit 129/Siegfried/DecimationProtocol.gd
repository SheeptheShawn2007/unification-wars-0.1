extends Skill
class_name DecimationProtocol

var spentSteel = false
var currSteel: Effect

func onUse(user: Character, target: Character, battleManager: BattleManager):
    currSteel = user.hasEffect("Steel")
    if currSteel != null:
        currSteel.apply(user, null, null)
        spentSteel = true
        
func onHit(user: Character, target: Character, battleManager: BattleManager):
    var str = Strength.new()
    if spentSteel:
        if target.keywords.has(Character.Keywords.STEEL):
            target.addEffect(str, 2, 4)
        target.addEffect(str, 2, 3)
    else:
        target.addEffect(str, 1, 2)
