extends Skill
class_name ThrustFreiherr

var baseAccuracy: int
func _ready():
    baseAccuracy = accuracyBonus

func onUse(user: Character, target: Character, battleManager: BattleManager):
    var currSteel = user.hasEffect("Steel")
    if !currSteel == null:
        accuracyBonus += 3*min(currSteel.count, 3)

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var newSteel = Steel.new()
    user.addEffect(newSteel, 2, 0)

func afterUse(user: Character, target: Character, battleManager: BattleManager):
    accuracyBonus = baseAccuracy
