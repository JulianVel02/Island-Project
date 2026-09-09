extends Area2D

@onready var sound_key: AudioStreamPlayer2D = $Sound_key
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.keys_collected += 1
		sound_key.play()
		collision_shape.call_deferred("set", "disabled", true)
		
		var tween = create_tween()
		tween.tween_property(sprite, "position:y", sprite.position.y - 20, 0.4)
		tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.4)
		tween.tween_callback(queue_free)
		
		print("Llave recogida!")
