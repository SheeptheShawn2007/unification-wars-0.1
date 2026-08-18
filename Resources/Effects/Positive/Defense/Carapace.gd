extends Effect
class_name Carapace

func _init():
    effectType = [EffectType.DEFENSE]
    alignment = EffectAlignment.POSITIVE
    effectName = "Carapace"
    showPotency = false

func apply(user: Character, target: Character, battleManager: BattleManager) -> int:
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    if user.keywords.has(Character.Keywords.STEEL):
        return 4
    return 3
