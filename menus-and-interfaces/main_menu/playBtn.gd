extends Button
@onready var PlayBtnBG = get_node("/root/MainMenu/PlayBtnBG")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	print("play")
	get_tree().change_scene_to_file("res://menus-and-interfaces/level_select/level_select.tscn")



func _on_mouse_entered() -> void:
	PlayBtnBG.visible = true


func _on_mouse_exited() -> void:
	PlayBtnBG.visible = false
