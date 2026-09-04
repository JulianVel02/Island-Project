extends Panel

@onready var dialogue_label: Label = $dialogue_label

var just_opened := false

# Apenas carga la escena el script le tiene que decir a Global que 
# emita npc_interacted
func _ready() -> void:
	Global.npc_interacted.connect(_on_npc_interacted)

func _on_npc_interacted(npc_name: String, text: String) -> void:
	dialogue_label.text = npc_name + ": " + text
	visible = true
	just_opened = true
	Global.dialogue_open = true
	
	print("Mostrando dialogo: ", text)

func _process(delta: float) -> void:
	if just_opened:
		just_opened = false
		return
	if visible and Input.is_action_just_pressed("interact"):
		visible = false
		Global.dialogue_open = false
