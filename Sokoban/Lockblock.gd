extends StaticBody2D

func unlock() -> void:
	$AnimationPlayer.play("Blink")

func dismiss() -> void:
	queue_free()
