extends Node

signal player_hit_enemy
# Nueva señal llamada player_hit_enemy
# Funciona como una flag?
# Cualquier script puede escucharla sin que el emisor sepa quien escucha

# Señal para interactuar con el npc
signal npc_interacted(npc_name: String, text: String)

var dialogue_open: bool = false
var player_current_attack = false
var next_spawn_posiion := Vector2.ZERO
