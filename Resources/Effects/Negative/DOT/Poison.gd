extends Effect
class_name Poison

func _init():
    effectType = [EffectType.DOT]
    alignment = EffectAlignment.NEGATIVE
    showPotency = true
    showCount = true
    effectName = "Poison"

func apply(user, target, battleManager:BattleManager):
    user.currHP -= potency
    count -= 1
    if count <= 0:
        user.removeEffect(self)
