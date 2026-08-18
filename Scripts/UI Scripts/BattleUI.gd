extends CanvasLayer
class_name BattleUI

@onready var battleManager = $"../BattleManager"
@onready var skillList = $SkillPanel/VBoxContainer/ScrollContainer/SkillList
@onready var turnOrderPanel = $TurnOrderPanel/HBoxContainer
@onready var characterName = $InfoPanel/VBoxContainer/CharacterName
@onready var hpBar = $InfoPanel/VBoxContainer/HPBar
@onready var mpBar = $InfoPanel/VBoxContainer/MPBar
var currentSkillIndex: int = 0
var currentTargetIndex: int = 0
var selectingTarget: bool = false
var validTargets: Array = []
var actingCharacter: Character = null
var selectedCharacter: Character = null

func _ready():
    $SkillPanel/VBoxContainer/HeadRow/NameHeader.custom_minimum_size.x = 500
    $SkillPanel/VBoxContainer/HeadRow/PosHeader.custom_minimum_size.x = 200
    $SkillPanel/VBoxContainer/HeadRow/TargetHeader.custom_minimum_size.x = 200
    $SkillPanel/VBoxContainer/HeadRow/TimeHeader.custom_minimum_size.x = 110
    $SkillPanel/VBoxContainer/HeadRow/MPHeader.custom_minimum_size.x = 110
    
    $SkillPanel/VBoxContainer/HeadRow/NameHeader.text = "Name"
    $SkillPanel/VBoxContainer/HeadRow/PosHeader.text = "Position"
    $SkillPanel/VBoxContainer/HeadRow/TargetHeader.text = "Targets"
    $SkillPanel/VBoxContainer/HeadRow/TimeHeader.text = "T. Mod"
    $SkillPanel/VBoxContainer/HeadRow/MPHeader.text = "Mana"

func showSkillButtons(character: Character):
    actingCharacter = character
    selectedCharacter = actingCharacter
    currentSkillIndex = 0
    
    for child in skillList.get_children():
        child.queue_free()
    
    for skill in character.skills:
        var row = HBoxContainer.new()
        
        var nameLabel = Label.new()
        nameLabel.text = skill.skillName
        nameLabel.custom_minimum_size.x = 500
        
        var posLabel = Label.new()
        posLabel.text = formatPositions(skill.selfPos, skill, "")
        posLabel.custom_minimum_size.x = 200
        
        var targetLabel = Label.new()
        targetLabel.text = formatPositions(skill.tarPos, skill, "t")
        targetLabel.custom_minimum_size.x = 200
        
        var timeLabel = Label.new()
        timeLabel.text = str(skill.timeCost)
        timeLabel.custom_minimum_size.x = 110
        
        var mpLabel = Label.new()
        mpLabel.text = str(skill.manaCost)
        mpLabel.custom_minimum_size.x = 110
        
        row.add_child(nameLabel)
        row.add_child(posLabel)
        row.add_child(targetLabel)
        row.add_child(timeLabel)
        row.add_child(mpLabel)
        
        skillList.add_child(row)
    
    updateSkillCursor()

func formatPositions(positions: Array, skill: Skill, case: String) -> String:
    var result = ""
    if case == "":
        for i in range(4, 0, -1): 
            if positions.has(i):
                result += "X"
            else:
                result += "O"
            if i > 0:
                result += " "
    else:
        for i in range(1, 5): 
            if positions.has(i):
                result += "X"
            else:
                result += "O"
            if i < 4:
                if (skill.targetType == Skill.TargetType.AOE_ENEMY or \
                skill.targetType == Skill.TargetType.AOE_ALLY) and case == "t":
                    result += "-"
                else:
                    result += " "
    return result

func setValidTargets(targets: Array):
    validTargets = targets
    selectingTarget = true
    currentTargetIndex = 0

func updateBars(character: Character):
    if character == null:
        return
    if character.maxMP <= 0:
        mpBar.visible = false
        hpBar.custom_minimum_size.y = 60
    else:
        mpBar.visible = true
        hpBar.custom_minimum_size.y = 30
    characterName.text = character.charName
    hpBar.max_value = character.maxHP
    hpBar.value = character.currHP
    hpBar.get_node("Label").text = str(character.currHP) + "/" + str(character.maxHP)
    mpBar.max_value = character.maxMP
    mpBar.value = character.currMP
    mpBar.get_node("Label").text = str(character.currMP) + "/" + str(character.maxMP)

func _input(event):
    if battleManager.state != BattleManager.GameState.WAITING:
        return
    if event is InputEventKey and event.pressed:
        if not selectingTarget:
            handleSkillInput(event)

func handleSkillInput(event: InputEventKey):
        match event.keycode:
            KEY_UP:
                currentSkillIndex = max(0, currentSkillIndex - 1)
                updateSkillCursor()
            KEY_DOWN:
                currentSkillIndex = min(actingCharacter.skills.size() - 1, currentSkillIndex + 1)
                updateSkillCursor()
            KEY_ENTER, KEY_SPACE:
                var skill = actingCharacter.skills[currentSkillIndex]
                battleManager.onSkillSelected(skill)
            KEY_ESCAPE:
                battleManager.selectedSkill = null
                battleManager.clearHighlights()

#func handleTargetInput(event: InputEventKey):
    #match event.keycode:
        #KEY_UP:
            #currentTargetIndex = max(0, currentTargetIndex - 1)
            #updateTargetCursor()
        #KEY_DOWN:
            #currentTargetIndex = min(validTargets.size() - 1, currentTargetIndex + 1)
            #updateTargetCursor()
        #KEY_ENTER, KEY_SPACE:
            #battleManager.onTargetSelected(validTargets[currentTargetIndex])
        #KEY_ESCAPE:
            #selectingTarget = false
            #battleManager.clearHighlights()

func updateSkillCursor():
    for i in skillList.get_children().size():
        skillList.get_child(i).modulate = Color.WHITE
    if skillList.get_children().size() > 0:
        skillList.get_child(currentSkillIndex).modulate = Color.YELLOW

func updateTargetCursor():
    if validTargets.is_empty():
        return
    battleManager.clearHighlights()
    validTargets[currentTargetIndex].setHighlight(true)

func highlightButton(slot: int):
    pass

func clearSkillMenu():
    print("Clearing", skillList.get_child_count(), "rows")
    for child in skillList.get_children():
        child.queue_free()
        skillList.remove_child(child)
