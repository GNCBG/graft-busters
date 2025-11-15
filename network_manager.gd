extends Control

# Network Setup
const PORT = 8910
const MAX_PEERS = 5

# Referensi Node (Pastikan nama node di Scene Dock Anda cocok)
@onready var host_button = $VBoxContainer/HostButton
@onready var join_button = $VBoxContainer/JoinButton
@onready var start_game_button = $VBoxContainer/StartGameButton

# --- NETWORK HANDLERS ---

func _ready():
	# Menghubungkan sinyal bawaan Godot untuk Network Peer
	Multiplayer.peer_connected.connect(on_peer_connected)
	Multiplayer.peer_disconnected.connect(on_peer_disconnected)
	
	# Atur UI awal
	start_game_button.disabled = true
	host_button.text = "HOST"
	join_button.text = "JOIN"
	start_game_button.text = "START GAME"

func create_host():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_PEERS)
	if error != OK:
		print("Error starting server: ", error)
		return
	Multiplayer.multiplayer_peer = peer
	print("Server started on port ", PORT)
	start_game_button.disabled = false
	host_button.disabled = true 
	join_button.disabled = true

func join_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client("127.0.0.1", PORT)
	if error != OK:
		print("Error joining client: ", error)
		return
	Multiplayer.multiplayer_peer = peer
	print("Client joined game.")
	host_button.disabled = true
	join_button.disabled = true

func start_game():
	Multiplayer.set_refuse_new_connections(true)
	rpc("switch_to_world_scene")

@rpc("call_local", "any_peer")
func switch_to_world_scene():
	get_tree().change_scene_to_file("res://World.tscn")

# --- SINYAL JARINGAN ---

func on_peer_connected(id):
	print("Peer connected with ID: ", id)

func on_peer_disconnected(id):
	print("Peer disconnected with ID: ", id)

# --- SINYAL UI (Penerima sinyal dari tombol) ---

func _on_host_button_pressed():
	create_host()

func _on_join_button_pressed():
	join_game()

func _on_start_game_button_pressed():
	start_game()


