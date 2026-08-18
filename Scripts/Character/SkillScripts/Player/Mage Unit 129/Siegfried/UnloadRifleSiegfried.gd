extends Skill
class_name UnloadRifle

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var selfAmmo = user.hasEffect("Ammo")
    if selfAmmo != null:
        damage = selfAmmo.count * 2
        damageVar = selfAmmo.count * 3
        for i in range(selfAmmo.count):
            selfAmmo.apply(user, target, battleManager)
    else:
        damage = 0
        damageVar = 0
