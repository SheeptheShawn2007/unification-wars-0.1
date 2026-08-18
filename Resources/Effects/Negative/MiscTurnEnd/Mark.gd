extends Effect
class_name Mark

func _init():
    effectType = [EffectType.MISCTURNEND]
    alignment = EffectAlignment.NEGATIVE
    effectName = "Mark"
    showPotency = false

func apply(user: Character, target: Character, battleManager: BattleManager):
    count -= 1
    if count <= 0:
        user.removeEffect(self)
