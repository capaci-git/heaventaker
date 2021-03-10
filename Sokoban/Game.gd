extends Node2D

onready var spots: = $Spots

signal game_end(result)

func _process(_delta):
	var spots_on: = $Spots.get_child_count()
	for i in spots.get_children():
		if i.occupied:
			spots_on -= 1
	
	if spots_on == 0:
		$AcceptDialog.popup()
		emit_signal("game_end")
