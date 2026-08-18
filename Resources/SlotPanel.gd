extends VBoxContainer

@onready var hpBar = $HPBar
@onready var mpBar = $MPBar
@onready var battleManager = $"../../../../../BattleManager"
@export var slotNumber: int
@export var enemySlot: bool

func getCharacter() -> Character:
    var party = battleManager.enemyParty if enemySlot\
    else battleManager.playerParty
    for slot in party.get_children():
        for child in slot.get_children():
            if child is VBoxContainer and child == self:
                for child2 in slot.get_children():
                    if child2 is Character:
                        return child2
    return null

func updateBars():
    var character = getCharacter()
    if character == null:
        mpBar.visible = false
        hpBar.visible = false
        return
    if character.maxMP <= 0:
        mpBar.visible = false
        hpBar.custom_minimum_size.y = 30
    else:
        mpBar.visible = true
        hpBar.custom_minimum_size.y = 15
    hpBar.max_value = character.maxHP
    hpBar.value = character.currHP
    hpBar.get_node("Label").text = str(character.currHP) + "/" + str(character.maxHP)
    mpBar.max_value = character.maxMP
    mpBar.value = character.currMP
    mpBar.get_node("Label").text = str(character.currMP) + "/" + str(character.maxMP)
