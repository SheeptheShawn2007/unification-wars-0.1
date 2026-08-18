extends Node
class_name TurnQueue

var characters: Array[Character] = []
var timers: Dictionary = {}

func addCharacter(character: Character):
    characters.append(character)
    timers[character] = character.speed
    
func tick():
    for character in characters:
        if character.state == Character.CharacterState.ALIVE or \
        character.state == Character.CharacterState.AT_ZERO_HP:
            timers[character] -= 1
            
func getNextCharacter() -> Character:
    var ready: Array[Character] = []
    for character in characters:
        if timers[character] <= 0:
            ready.append(character)
            
    ready.sort_custom(func(a,b): return timers[a] < timers[b])
    if ready.size() > 0:
        print("Character ready!")
        return ready[0]
    return null
    
func resetTimer(character: Character, skillCost: int, battleManager: BattleManager):
    character.tick(battleManager)
    var randomBonus: int = randi_range(1,4)
    timers[character] = character.speed + skillCost +randomBonus

func removeCharacter(character: Character):
    characters.erase(character)
    timers.erase(character)
