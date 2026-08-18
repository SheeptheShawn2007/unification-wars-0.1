extends Skill
class_name ObscurationProtocol

var spentSteel
var currSteel: Effect

func onUse(user: Character, target: Character, battleManager: BattleManager):
    currSteel = user.hasEffect("Steel")
    if currSteel != null:
        currSteel.apply(user, null, null)
        spentSteel = true
    

func onHit(user: Character, target: Character, battleManager: BattleManager):
    target.dodge += 25
    var obscu = Obscuration.new()
    if spentSteel:
        target.addEffect(obscu, 2, 0)
