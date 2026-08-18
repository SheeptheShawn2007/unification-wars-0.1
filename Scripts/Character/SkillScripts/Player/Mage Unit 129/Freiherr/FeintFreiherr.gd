extends Skill
class_name FeintFreiherr

var baseDamage: int
func _onready():
    baseDamage = damage

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var currSteel = user.hasEffect("Steel")
    if !currSteel == null:
        var damageBonus = max(0, currSteel.count - 2)
        damageBonus = min(3, damageBonus)

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var newSteel = Steel.new()
    user.addEffect(newSteel, 1, 0)

func afterUse(user: Character, target: Character, battleManager: BattleManager):
    damage = baseDamage
