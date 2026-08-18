extends Effect
class_name Protection

func _init():
    effectType = [EffectType.DEFENSE]
    alignment = EffectAlignment.POSITIVE
    effectName = "Protection"

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    return potency
