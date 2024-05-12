extends Control

@onready var port : int
@onready var address : String 
var peer

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


func peer_connected(id):
	print("Player Connected " + str(id))
	
	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	Global.playerName.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
			
			
func connected_to_server():
	print("connected to Server!")
	SendPlayerInformation.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())
	
	
func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer")
func SendPlayerInformation(name, id):
	if !Global.playerName.has(id):
		Global.playerName[id] ={
			"name" : name,
			"id" : id,
			"score": 0
		}
		
	if multiplayer.is_server():
		for i in Global.playerName:
			SendPlayerInformation.rpc(Global.playerName[i].name, i)
			
@rpc("any_peer", "call_local")
func StartGame():
	var scene = load("res://scenes/MainScene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("cannot host: " +  str(error))
		return
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	print("Adress: " + address)
	print("Port: " + str(port))
	
func _on_host_pressed():
	hostGame()
	SendPlayerInformation($LineEdit.text, multiplayer.get_unique_id())
	
	
func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, int(port))
	multiplayer.set_multiplayer_peer(peer)
	print(address)
	print(port)
	


func _on_quit_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	StartGame.rpc()


func _on_address_text_submitted(new_text):
	address = $address.text




func _on_port_text_submitted(new_text):
	port = int($port.text)
