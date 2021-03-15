extends Area2D

var occupied: = false

func _on_Spot_body_entered(body):
	occupied = true
	if body.is_in_group('box'):
		occupied = true

func _on_Spot_body_exited(body):
	occupied = false
	if body.is_in_group('box'):
		occupied = false
