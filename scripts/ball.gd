extends CharacterBody2D

var win_size : Vector2
@export var start_speed : int = 500
@export var accel : int = 50
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.6

signal ball_timer_timeout

func _ready():
	win_size = get_viewport_rect().size
	$".".add_to_group("Ball")
	
func _physics_process(delta):
	var collision = move_and_collide(dir * speed * delta)
	var collider 
	if collision:
		collider = collision.get_collider()
		if collider.is_in_group("Player"):
			speed += accel
			dir = new_direction(collider)
			$AudioStreamPlayer2D.play()
		else:
			dir = dir.bounce(collision.get_normal())

func spawn_ball():
	position.x = win_size.x / 2
	position.y = randi_range(200, win_size.y - 200)
	speed = start_speed
	dir = random_direction()
	
func random_direction() -> Vector2:
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = [-1, 1].pick_random()
	return new_dir.normalized()

func new_direction(collider) -> Vector2:
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	return new_dir.normalized()





func _on_ball_timer_timeout():
	emit_signal("ball_timer_timeout")
	
