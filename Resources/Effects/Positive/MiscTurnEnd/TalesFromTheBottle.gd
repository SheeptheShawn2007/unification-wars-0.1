extends Effect
class_name TalesFreiherr

func _init():
    effectType = [EffectType.MISCTURNEND, EffectType.ACCURACY]
    alignment = EffectAlignment.POSITIVE
    effectName = "Tales"
    showPotency = false

func apply(user: Character, target: Character, battleManager: BattleManager):
    if battleManager.state == BattleManager.GameState.DODGING:
        return 10
    elif  battleManager.state == BattleManager.GameState.ENDING:
        user.currMP += 2
        user.currMP = min(user.currMP, user.maxMP)
        count -= 1
        if count <= 0:
            user.removeEffect(self)
