extends StaticBody2D


func pick() -> void:
	$AnimationPlayer.play("Pick")

func dismiss() -> void:
	queue_free()
