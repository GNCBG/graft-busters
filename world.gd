extends Node2D

# --- PRELOAD SCENES (Pastikan Path ini benar!) ---
# Jika scene Anda ada di root proyek: res://Tikus.tscn
const TIKUS_SCENE = preload("res://Tikus.tscn")
const MAHASISWA_SCENE = preload("res://Mahasiswa.tscn")

# Array yang berisi pilihan scene karakter
const PLAYER_CHARACTERS = [TIKUS_SCENE, MAHASISWA_SCENE]

# Posisi spawn awal (untuk acak)
var spawn_positions = [
	Vector2(200, 100),  # Spawn 1
	Vector2(400, 100),  # Spawn 2
	Vector2(600, 100),  # Spawn 3
	Vector2(800, 100),  # Spawn 4
	Vector2(1000, 100) # Spawn 5
]

# Variabel untuk referensi Multiplayer Spawner (TIDAK DIPAKAI SAAT LOKAL)
@onready var multiplayer_spawner = $MultiplayerSpawner

func _ready():
	# Ini adalah logika untuk MENGUJI LOKAL SAAT PENGEMBANGAN CEPAT.
	# Selalu spawn karakter untuk pemain lokal dengan ID 1.
	spawn_player(1) 

	# --- KODE MULTIPLAYER (DIKOMENTARI UNTUK PENGEMBANGAN LOKAL) ---
	# if Multiplayer.is_server():
	#     # Spawn karakter untuk Server itu sendiri
	#     # spawn_player(Multiplayer.get_unique_id())
		
	#     # Hubungkan sinyal ketika pemain lain terhubung (peer)
	#     # Multiplayer.peer_connected.connect(spawn_player)
		
	#     # Sinyal saat peer terputus (untuk menghapus karakter mereka)
	#     # Multiplayer.peer_disconnected.connect(remove_player)
	# -----------------------------------------------------------------

# Fungsi yang dipanggil di Server untuk memunculkan karakter baru
# DIKEMBALIKAN KE FUNGSI BIASA UNTUK TESTING LOKAL
func spawn_player(id):
	# 1. Pilih karakter secara acak (Tikus atau Mahasiswa)
	var random_index = randi() % PLAYER_CHARACTERS.size()
	var selected_scene = PLAYER_CHARACTERS[random_index]

	# 2. Instansiasi (buat) karakter
	var player_instance = selected_scene.instantiate()
	
	# 3. Tetapkan otoritas multiplayer ke peer yang baru terhubung (DIHAPUS SEMENTARA)
	# player_instance.set_multiplayer_authority(id) 
	
	# 4. Atur posisi spawn
	var spawn_pos_index = min(id - 1, spawn_positions.size() - 1)
	player_instance.global_position = spawn_positions[spawn_pos_index]
	
	# 5. Tambahkan karakter ke World (NON-MULTIPLAYER SPAWNING)
	add_child(player_instance)
	
# Fungsi untuk menghapus karakter ketika peer terputus (TIDAK DIPAKAI SAAT LOKAL)
func remove_player(id):
	# KODE INI HANYA AKAN BERJALAN JIKA KODE MULTIPLAYER DI _ready() DIHILANGKAN KOMENTARNYA
	# for player in get_children():
	#     if player is CharacterBody2D and player.get_multiplayer_authority() == id:
	#         player.queue_free()
	#         break
	pass # Tambahkan 'pass' agar fungsi tidak kosong
