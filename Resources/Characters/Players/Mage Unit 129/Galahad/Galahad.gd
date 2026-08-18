extends Character
class_name Galahad

func onBattleStart(battleManager: BattleManager):
    var newAmmo = Ammo.new()
    self.addEffect(newAmmo, 4, 0)

func onTurnEnd(battleManager: BattleManager):
    if hasEffect("Steel"):
        defense += 1
