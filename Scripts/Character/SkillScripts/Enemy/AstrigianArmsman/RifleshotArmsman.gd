extends Skill
class_name RifleshotArmsman

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var selfAmmo = user.hasEffect("Blessed Ammunition")
    if selfAmmo != null:
        selfAmmo.apply(user, target, battleManager)
        damage = 7
        pierce = 4
        accuracyBonus = 15
        skillName = "Blessed Rifle Fire"
        
func afterUse(user: Character, target: Character, battleManager: BattleManager):
    damage = 5
    pierce = 1
    accuracyBonus = 5
    skillName = "Rifle Shot"
