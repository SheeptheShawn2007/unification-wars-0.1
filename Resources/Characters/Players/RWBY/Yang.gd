extends Character

func onBattleStart(battlemanager: BattleManager):
    var newAmmo = CelicaShell.new()
    self.addEffect(newAmmo, 24, 0)

func onHit(target: Character, battleManager: BattleManager):
    var newAbsor = KineticAbsorption.new()
    self.addEffect(newAbsor, 1, 0)

func onTurnEnd(battleManager: BattleManager):
    var currBurn = self.hasEffect("Burn")
    if currBurn != null:
        currBurn.potency = currBurn.potency/2
