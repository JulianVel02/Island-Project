extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var health = 100
var player_in_attack_zone = false
var can_take_damage = true
var is_dying = false

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

@onready var sprite_skul: AnimatedSprite2D = $sprite_skul
@onready var life_bar = $life_bar

func _physics_process(delta: float) -> void:
	deal_with_damage()
	if is_dying:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Aplico el empujon cuando esta actuvo. Se le agrega una condición arriba del 
	# player_chase para que mientras dure el knockback. ignore la persecución
	if knockback_timer > 0:
		velocity = knockback
		print("Frame de knockback - velocity: ", velocity, " - posicion: ", global_position)
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
	elif player_chase:
		#position += (player.position - position)/speed
		#velocity = direction * speed
		var direction = (player.global_position - global_position).normalized() # Se cambío la forma en la que se calcula 
																				# la posición del enemigo mediante vectores
		velocity = direction * speed
		
		sprite_skul.play("walk_side")
		if direction.x < 0:
			sprite_skul.flip_h = true
		else:
			sprite_skul.flip_h = false
	else:
		velocity = Vector2.ZERO
		sprite_skul.play("idle_down")
	
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass
	

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_zone = false

func deal_with_damage():
	if is_dying:
		return
	if player_in_attack_zone and Global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 30
			life_bar.update_health(health, 100)
			Global.player_hit_enemy.emit() # Avisamos que el jugador conectó un golpe
			$take_dmage_cooldown.start()
			can_take_damage = false
			print("Skul Health = ", health)
			
			# global_position - player.global_position apunta al ENEMIGO, asi sale disparado
			var knockback_directon = (global_position - player.global_position).normalized()
			apply_knockback(knockback_directon, 90, 0.12)
			player.apply_knockback(-knockback_directon, 50, 0.1)
			print("Knockback aplicado: ", knockback, " | timer: ", knockback_timer)
			
			flash_hit()
			
			if health <= 0:
				is_dying = true
				sprite_skul.play("dying")


func _on_take_dmage_cooldown_timeout() -> void:
	can_take_damage = true


# Se activa la función que dispara el empujon
func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	

func flash_hit() -> void:
	sprite_skul.modulate = Color(1.0, 0.0, 0.0, 1.0) #color 
	var tween = create_tween()
	tween.tween_property(sprite_skul, "modulate", Color(1,1,1), 0.15)

func _on_sprite_skul_animation_finished() -> void:
	if sprite_skul.animation == "dying":
		queue_free()
