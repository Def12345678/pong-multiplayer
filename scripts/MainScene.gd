extends Sprite2D


@export var player_scene: PackedScene
var playerNameTag = Global.playerName

var scorePoints := [0, 0] 
const PADDLE_SPEED : int = 500

var win_size : Vector2

@onready var player_positions = [Vector2(50, 324), Vector2(1102, 324)]
var host_pos = Vector2(50, 324)
var client_pos = Vector2(1102, 324)


@onready var ball = $Ball
@onready var score = $Scores
@onready var timer = $Ball/BallTimer



	

	
func _ready():
	
	
	
	win_size = get_viewport_rect().size
	ball.connect("ball_timer_timeout", _spawn_balle)
	
	var index = 0
	for i in Global.playerName:
		var currentPlayer = player_scene.instantiate()
		currentPlayer.name = str(Global.playerName[i].id)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("SpawnLocation"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
	_spawn_balle()



func _spawn_balle():
	ball.spawn_ball()



func _on_score_right_body_entered(body):
	scorePoints[1] += 1
	$Scores/RightScore.text = str(scorePoints[1])
	timer.start()



func _on_score_left_body_entered(body):
	scorePoints[0] += 1
	$Scores/LeftScore.text = str(scorePoints[0])
	timer.start()





