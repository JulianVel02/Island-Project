extends CharacterBody2D

const SPEED = 80.0

@onready var sprite: AnimatedSprite2D = $sprite
@onready var hit: AudioStreamPlayer2D = $hit
@onready var shake_camera: Camera2D = $camera2d
@onready var life_bar: TextureProgressBar = $life_bar


var last_direction := "down"
var is_attacking := false
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var health = 150
var player_alive = true

var attack_ip = false
# ip: in progress

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0


func _ready() -> void:
	Global.player_hit_enemy.connect(shake_camera.trigger_shake)
	# Se suscribe a la señal. Cada vez que alguien emita player_hit_enemy, se ejecuta shake_camera.trigger...
	# automaticamente, sin que esta funcion tenga que hacer nada mas
	
	#Godot emite una señal automaticamente
	#cuando una animación termina de reproducirse
	#sprite.animation_finished.connect(_on_animation_finished)
	if Global.next_spawn_posiion != Vector2.ZERO and get_tree().current_scene.name == "scene_01":
		global_position = Global.next_spawn_posiion
		Global.next_spawn_posiion = Vector2.ZERO

func _physics_process(delta: float) -> void:
	enemy_attack()
	
	if health <= 0:
		player_alive = false # <= add end screen
		health = 0
		print("Jugador eliminado!")
		self.queue_free()
	

	if Input.is_action_just_pressed("attack_space") and not is_attacking:
		start_attack()
		hit.play()
		
	if knockback_timer > 0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
		move_and_slide()
		return
		
	if is_attacking:
		# Mientras ataca no se mueve, salimos rapido de la funcion
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		update_facing(direction)
		play_animation("walk")
	else:
		velocity = Vector2.ZERO
		play_animation("idle")
		
	move_and_slide()

func update_facing(direction: Vector2) -> void:
	# Se compara que eje domina para decidir si mostramos animación
	# horizontal o vertical cuando el jugador camina en diagonal.
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			last_direction = "right" 
		else:
			last_direction = "left"
	else:
		if direction.y > 0:
			last_direction = "down"
		else:
			last_direction = "up"


func play_animation(prefix: String) -> void:
	if last_direction == "left" or last_direction == "right":
		sprite.flip_h = last_direction == "left"
		sprite.play(prefix + "_side")
	else:
		sprite.flip_h = false
		sprite.play(prefix + "_" + last_direction)
		
func start_attack() -> void:
	is_attacking = true
	attack_ip = true
	Global.player_current_attack = true
	play_animation("attack")
	$deal_attack_timer.start()



func _on_sprite_animation_finished() -> void:
	if sprite.animation.begins_with("attack"):
		is_attacking = false

func player():
	pass

func _on_player_hitbow_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true


func _on_player_hitbow_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 10
		life_bar.update_health(health, 150)
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func _on_deal_attack_timer_timeout() -> void:
	attack_ip = false
	Global.player_current_attack = false
	
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
