extends Effect
class_name NobleTechniqueEffect

func _init():
    effectType = [EffectType.DODGE]
    alignment = EffectAlignment.POSITIVE
    effectName = "Noble Technique"
    showCount = false
    showCount = false

func apply(user: Character, target: Character, battleManager: BattleManager):
    if user.keywords.has(Character.Keywords.STEEL):
        return 12
    return 8
