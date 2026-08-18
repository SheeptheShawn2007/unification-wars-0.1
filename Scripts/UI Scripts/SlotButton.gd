extends Button

@onready var battleManager = $"../../../../../BattleManager"
@export var slotNumber: int
@export var enemySlot: bool

var highlighted: bool = false
var highlight: StyleBoxFlat = preload("res://Resources/Textures/SlotButtonHighlight.tres")
var normal: StyleBoxFlat = preload("res://Resources/Textures/SlotButtonNormal.tres")
var occupied: StyleBoxFlat = preload("res://Resources/Textures/SlotButtonOccupied.tres")

func _ready():
    gui_input.connect(buttonPressed)

func buttonPressed(event: InputEventMouseButton):
    if battleManager.state != BattleManager.GameState.WAITING:
        return
    if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
        if !highlighted:
            battleManager.onSlotSelected(slotNumber, enemySlot)
        else:
            battleManager.onTargetSelected(getCharacter(self))

func setHighlight(highlightedButton: bool):
    if highlightedButton:
        add_theme_stylebox_override("normal", highlight)
        highlighted = true
    else:
        if getCharacter(self) != null:
            add_theme_stylebox_override("normal", occupied)
        else:
            add_theme_stylebox_override("normal", normal)

func getCharacter(button: Button) -> Character:
    var party = battleManager.enemyParty if enemySlot\
    else battleManager.playerParty
    for slot in party.get_children():
        for child in slot.get_children():
            if child is Button and child == self:
                for child2 in slot.get_children():
                    if child2 is Character:
                        return child2
    return null
