extends Skill

func onUse(user: Character, target: Character, battleManager: BattleManager):
    battleManager.moveCharacter(battleManager.enemyParty, user, user.rankPosition - 1)
