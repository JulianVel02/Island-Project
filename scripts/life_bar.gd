extends TextureProgressBar

@onready var hide_timer: Timer = $hide_timer

func _ready() -> void:
	visible = false # empieza escondida
	
func update_health(current: float, max_health: float) -> void:
	max_value = max_health
	value = current
	visible = true
	hide_timer.start() # se reinicia la cuenta de 2 segundos por llamada

func _on_hide_timer_timeout() -> void:
	visible = false
