extends Skill
class_name DeclareDuel

func onHit(user: Character, target: Character, battleManager: BattleManager):
    var stealthList = target.getEffectsType(Effect.EffectType.STEALTH)
    for stealth in stealthList:
        target.removeEffect(stealth)
    var newDuel = DuelFreiherr.new()
    target.addEffect(newDuel, 3, 0)
