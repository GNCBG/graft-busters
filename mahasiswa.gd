extends CharacterBody2D

# Konstanta Gerakan
const SPEED = 300.0             # Kecepatan lari horizontal
const JUMP_VELOCITY = -450.0    # Kekuatan lompatan vertikal
const gravity = 980.0           # Nilai gravitasi

# Referensi Node
@onready var animated_sprite = $AnimatedSprite2D 

func _physics_process(delta: float):
	
	# 1. Terapkan Gravitasi
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Tangani Lompatan
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Tangani Gerakan Horizontal (Lari)
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		# Membalik sprite (flip_h) agar menghadap arah gerakan
		animated_sprite.flip_h = direction < 0 
	else:
		# Pengereman/Stop 
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Logika Animasi
	if not is_on_floor():
		# Panggil animasi lompat
		animated_sprite.play("jump") 
	elif direction != 0:
		# Panggil animasi lari: "run"
		animated_sprite.play("run") 
	else:
		# Panggil animasi diam: "idle_1" (Ganti dengan nama idle utama Anda)
		animated_sprite.play("idle_1")
		
	# 5. Pindahkan dan Deteksi Kolisi
	move_and_slide()
