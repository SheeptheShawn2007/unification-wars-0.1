extends Effect
class_name Strength

func _init():
    effectType = [EffectType.DAMAGE]
    alignment = EffectAlignment.POSITIVE
    effectName = "Strength"

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    return self.potency
