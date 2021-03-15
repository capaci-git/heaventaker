extends Node2D

onready var spots: = $Spots
export (String) var chapter: = "IX"
export (int) var player_moves: = 10

signal game_end(result)

func _ready():
	$TextureRect/MovesLabel.text = String(player_moves)
	$TextureRect2/ChapterLabel.text = chapter

func _unhandled_input(event):
	if event.is_action_pressed('restart'):
		get_tree().reload_current_scene()

func _process(_delta):
	var spots_on: = $Spots.get_child_count()
	for i in spots.get_children():
		if i.occupied:
			spots_on -= 1
	
	if spots_on == 0:
		$AnimationPlayer.play("Blink")
		emit_signal("game_end", 1)

func _on_Player_moving():
	player_moves -= 1
	$TextureRect/MovesLabel.text = String(player_moves)
	if player_moves <= 0:
		$Player/AnimationPlayer.play("Death")
	
