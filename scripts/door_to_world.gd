extends Area2D

@export_file("*.tscn") var target_scene: String
# Declaramos una variable nueva llamada target_scene que almacena String
# @export_file convierte la variable en un campo visible en el inspector
@export var remember_position: bool = false
@export var spawn_offset: Vector2 = Vector2.ZERO
@export var requires_keys: bool = false
@export var keys_needed: int = 0


func _on_body_entered(body: Node2D) -> void:
# Llamamos a la funcion cuando Body entra en el area 2d de nuestra puerta
	if body.has_method("player"):
	# Le preguntamos a body si tiene una funcion llamada player (funcion que existe justamente en player.gd)
		if remember_position: # si remember_position es verdadero:
			Global.next_spawn_posiion = body.global_position +spawn_offset
			# La posición del jugador en el mundo justo antes de tocar el area door.
			
		if requires_keys and Global.keys_collected < keys_needed:
			print("Faltan llaves!")
		else:
			get_tree().call_deferred("change_scene_to_file", target_scene)
		# get_tree da acceso al arbol completo de nodos en la escena cargada
		# change_... le dice al arbol que borre todo y vuelva a cargar de 0 el archivo guardado en target_scene
