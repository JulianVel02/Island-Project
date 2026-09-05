extends Area2D

# Flag pra saber si el jugador está en rango o no de interacción
var player_in_range: bool = false



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.keys_collected += 1
		player_in_range = true
		queue_free()
		print("Llave recogida!")
