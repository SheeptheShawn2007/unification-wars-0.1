extends Skill
class_name AimedRifleShot

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var targetMark = target.hasEffect("Mark")
    var selfAmmo = user.hasEffect("Ammo")
    if targetMark != null:
        damage += damage
    if selfAmmo != null:
        selfAmmo.apply(user, target, battleManager)
    else:
        damage = 0
        damageVar = 0
    

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var targetMark = target.hasEffect("Mark")
    if targetMark != null:
        var newSteel = Steel.new()
        user.addEffect(newSteel, 1, 0)
