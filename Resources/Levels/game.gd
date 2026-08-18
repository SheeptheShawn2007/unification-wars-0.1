extends Node

@onready var battleManager = $Battle/BattleManager

func _ready():
    var player1 = preload("res://Resources/Characters/Players/Mage Unit 129/Freiherr/Freiherr.tscn").instantiate()
    var player2 = preload("res://Resources/Characters/Players/Mage Unit 129/Siegfried/Siegfried.tscn").instantiate()
    var enemy1 = preload("res://Resources/Characters/Enemies/LaticianRifleman/LaticianRifleman.tscn").instantiate()
    var enemy2 = preload("res://Resources/Characters/Enemies/LaticianRifleman/LaticianRifleman.tscn").instantiate()
    var enemy3 = preload("res://Resources/Characters/Enemies/LaticianTrenchSweeper/LaticianTrenchSweeper.tscn").instantiate()
    
    var players: Array[Character] = []
    var enemies: Array[Character] = []
    players.append(player1)
    players.append(player2)
    enemies.append(enemy1)
    enemies.append(enemy2)
    enemies.append(enemy3)
    
    battleManager.initBattle(players, enemies)
