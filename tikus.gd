extends CharacterBody2D

# Konstanta Gerakan
const SPEED = 300.0             # Kecepatan lari horizontal
const JUMP_VELOCITY = -450.0    # Kekuatan lompatan vertikal
const gravity = 980.0           # Nilai gravitasi (percepatan ke bawah)

# Referensi Node
@onready var animated_sprite = $AnimatedSprite2D 

func _physics_process(delta: float):
	
	# 1. Terapkan Gravitasi
	# Jika karakter tidak menyentuh lantai, tambahkan gravitasi ke kecepatan Y
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. Tangani Lompatan
	# Lompat hanya jika tombol 'ui_accept' ditekan DAN karakter ada di lantai
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Tangani Gerakan Horizontal (Lari)
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		# Membalik sprite (flip_h) agar menghadap arah gerakan
		animated_sprite.flip_h = direction < 0 
	else:
		# Pengereman/Stop (menggerakkan kecepatan ke 0 secara bertahap)
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Logika Animasi
	if not is_on_floor():
		# Asumsi Anda membuat animasi bernama 'jump'
		animated_sprite.play("jump") 
	elif direction != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
		
	# 5. Pindahkan dan Deteksi Kolisi
	# Fungsi bawaan CharacterBody2D yang menerapkan gerakan dan fisika
	move_and_slide()
