extends Effect
class_name Vulnerable

func _init():
    effectType = [EffectType.DEFENSE]
    alignment = EffectAlignment.NEGATIVE
    effectName = "Vulnerable"

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    return self.potency
