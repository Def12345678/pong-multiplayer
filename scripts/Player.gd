extends StaticBody2D

var win_height : int
var p_height : int

@onready var mainScene = get_parent()

func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $PlayerBody.get_size().y
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if Input.is_action_pressed("UP") or Input.is_action_pressed("ui_up"):
			position.y -= mainScene.PADDLE_SPEED * delta
		elif Input.is_action_pressed("DOWN") or Input.is_action_pressed("ui_down"):
			position.y += mainScene.PADDLE_SPEED * delta
			
		position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)
	
