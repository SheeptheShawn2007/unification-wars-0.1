extends Effect
class_name KineticAbsorption

func _init():
    effectType = [EffectType.CHARGE]
    alignment = EffectAlignment.POSITIVE
    effectName = "Kinetic Absorption"
    showPotency = false

func apply(user: Character, target: Character, battleManager: BattleManager):
    count -= 1
    if count <= 0:
        user.removeEffect(self)
