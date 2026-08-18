extends Effect
class_name Daze

func _init():
    effectType = [EffectType.SPEED]
    alignment = EffectAlignment.NEGATIVE
    effectName = "Daze"

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    return self.potency
