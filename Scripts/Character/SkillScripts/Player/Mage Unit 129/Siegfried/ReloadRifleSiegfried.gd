extends Skill
class_name ReloadRifle

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var selfAmmo = user.hasEffect("Ammo")
    if selfAmmo != null:
        selfAmmo.count = max(5, selfAmmo.count)
    else:
        var newAmmo = Ammo.new()
        user.addEffect(newAmmo, 5, 0)
