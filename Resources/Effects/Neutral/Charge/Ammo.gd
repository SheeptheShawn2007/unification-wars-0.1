extends Effect
class_name Ammo

func _init():
    effectType = [EffectType.CHARGE]
    alignment = EffectAlignment.NEUTRAL
    effectName = "Ammo"

func apply(user: Character, target: Character, battleManager: BattleManager):
    count -= 1
    if count <= 0:
        user.removeEffect(self)
