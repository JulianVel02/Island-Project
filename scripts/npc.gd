extends StaticBody2D

@export var dialogue_text: String = "Hola viajero."
@export var npc_name: String = "Aldeano"

# Flag pra saber si el jugador está en rango o no de interacción
var player_in_range: bool = false

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = true
		print("Entró")

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_range = false

# Función _process(_delta) que ejecuta cada frame
func _process(_delta: float) -> void:
	# Chequeamos que el jugador cumppla DOS condiciones:
	# 1. Está en rango / 2. Accionó interact (E)
	if player_in_range and not Global.dialogue_open and Input.is_action_just_pressed("interact"):
		# Emite la señal de interacción
		print("Interactuó con: ", npc_name)
		Global.npc_interacted.emit(npc_name, dialogue_text)
