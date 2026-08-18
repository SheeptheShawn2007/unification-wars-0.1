extends Effect
class_name Obscuration

func _init():
    effectType = [EffectType.DODGE]
    alignment = EffectAlignment.POSITIVE
    effectName = "Steel Shroud"
    showPotency = false

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    if user.keywords.has(Character.Keywords.STEEL):
        return 25
    return 15
