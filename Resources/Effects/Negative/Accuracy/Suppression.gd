extends Effect
class_name Suppression

func _init():
    effectType = [EffectType.ACCURACY]
    alignment = EffectAlignment.NEGATIVE
    effectName = "Suppression"

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    return self.potency
