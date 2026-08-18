extends Effect
class_name Regen

func _init():
    effectType = [EffectType.DOT]
    alignment = EffectAlignment.POSITIVE
    effectName = "Regeneration"

func apply(user: Character, target: Character, battleManager: BattleManager):
    user.currHP += potency
    user.currHP = min(user.currHP, user.maxHP)
    count -= 1
    if count <= 0:
        user.removeEffect(self)
