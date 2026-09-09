extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/scene_01.tscn")

func _on_options_pressed() -> void:
	print("Button Pressed")

func _on_exit_pressed() -> void:
	get_tree().quit()
