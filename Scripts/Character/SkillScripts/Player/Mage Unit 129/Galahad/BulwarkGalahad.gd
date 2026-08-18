extends Skill
class_name BulwarkGalahad

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var currSteel = user.hasEffect("Steel")
    var spentSteel = false
    if currSteel != null:
        currSteel.apply(user, null, null)
        spentSteel = true
    var newProtection = Protection.new()
    if spentSteel:
        user.addEffect(newProtection, 5, 1)
    else:
        user.addEffect(newProtection, 2, 1)
    
