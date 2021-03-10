extends KinematicBody2D

onready var ray: = $RayCast2D
export (int) var grid_size = 100

var inputs = {
	'ui_up': Vector2.UP,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
	'ui_down': Vector2.DOWN
}

func _unhandled_input(event):
	for dir in inputs:
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	var vector_next_pos: Vector2 = inputs[dir] * grid_size
	ray.cast_to = vector_next_pos/6
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		position += vector_next_pos
		print(true)
		return
	else:
		var collider = ray.get_collider()
		if collider.is_in_group('box'):
			if collider.move(dir):
				position += vector_next_pos
			return
	print(false)
	
