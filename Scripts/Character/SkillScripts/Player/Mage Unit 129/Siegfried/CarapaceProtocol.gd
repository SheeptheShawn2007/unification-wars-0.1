extends Skill
class_name CarapaceProtocol

var spentSteel = false
var currSteel: Effect

func onUse(user: Character, target: Character, battleManager: BattleManager):
    currSteel = user.hasEffect("Steel")
    if currSteel != null:
        currSteel.apply(user, null, null)
        spentSteel = true
        
func onHit(user: Character, target: Character, battleManager: BattleManager):
    var cara = Carapace.new()
    if spentSteel:
        target.addEffect(cara, 3, 0)
    else:
        target.addEffect(cara, 1, 0)
