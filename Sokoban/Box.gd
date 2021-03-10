extends KinematicBody2D

onready var ray: = $RayCast2D
var grid_size: = 100

var inputs = {
	'ui_up': Vector2.UP,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT,
	'ui_down': Vector2.DOWN
}

func move(dir):
	var vector_next_pos: Vector2 = inputs[dir] * grid_size
	ray.cast_to = vector_next_pos/6
	ray.force_raycast_update()
	
	print(ray.is_colliding())
	if !ray.is_colliding():
		position += vector_next_pos
		return true
	
	return false
