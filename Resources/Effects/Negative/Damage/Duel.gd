extends Effect
class_name DuelFreiherr

func _init():
    effectType = [EffectType.DEFENSE, EffectType.DODGE, EffectType.MISCTURNEND]
    alignment = EffectAlignment.NEGATIVE
    effectName = "Duel"

func apply(user: Character, target: Character, battleManager: BattleManager):
    if battleManager.state == BattleManager.GameState.DODGING:
        return -10
    if battleManager.state == BattleManager.GameState.HITTING:
        if target.keywords.has(Character.Keywords.STEEL):
            var newSteel = Steel.new()
            target.addEffect(newSteel, 1, 0)
    if battleManager.state == BattleManager.GameState.ENDING:
        count -= 1
    if count <= 0:
        user.removeEffect(self)
    
