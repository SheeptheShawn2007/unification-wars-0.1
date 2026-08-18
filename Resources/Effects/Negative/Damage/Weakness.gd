extends Effect
class_name Weakness

func _init():
    effectType = [EffectType.DAMAGE]
    alignment = EffectAlignment.NEGATIVE
    effectName = "Weakness"

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    return self.potency
