extends Character
class_name Freiherr

func onDown(target: Character, battleManager:BattleManager):
    var newSteel = Steel.new()
    addEffect(newSteel, 1, 0)

func onKill(battleManager: BattleManager):
    var newSteel = Steel.new()
    addEffect(newSteel, 1, 0)
