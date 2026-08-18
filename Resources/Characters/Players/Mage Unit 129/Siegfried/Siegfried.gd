extends Character

func onBattleStart(battleManager: BattleManager):
    var newAmmo = Ammo.new()
    self.addEffect(newAmmo, 5, 0)
    var value = -1
    for player in battleManager.getPartyMembers(battleManager.playerParty):
        if player.state == CharacterState.ALIVE:
            value += 1
    dodge += max(value, 0) * 10
    defense += max(value-1, 0)

func onTurnEnd(battleManager: BattleManager):
    var value = -1
    for player in battleManager.getPartyMembers(battleManager.playerParty):
        if player.state == CharacterState.ALIVE:
            value += 1
    dodge += max(value, 0) * 10
    defense += max(value-1, 0)
