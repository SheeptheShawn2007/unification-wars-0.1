extends Effect
class_name CelicaShell

func _init():
    effectType = [EffectType.CHARGE]
    alignment = EffectAlignment.NEUTRAL
    effectName = "Celica Shell"

func apply(user: Character, target: Character, battleManager: BattleManager):
    count -= 1
    if count <= 0:
        user.removeEffect(self)
