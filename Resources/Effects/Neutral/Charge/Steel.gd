extends Effect
class_name Steel

func _init():
    effectType = [EffectType.CHARGE]
    alignment = EffectAlignment.POSITIVE
    effectName = "Steel"

func apply(user: Character, target: Character, battleManager: BattleManager):
    count -= 1
    if count <= 0:
        user.removeEffect(self)
