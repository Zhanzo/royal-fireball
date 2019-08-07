extends Node


func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()


func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/TextureButton.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton.grab_focus()
	elif $MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/TextureButton2.grab_focus()


func _on_TextureButton_pressed():
	get_tree().change_scene("StageOne.tscn")


func _on_TextureButton2_pressed():
	get_tree().quit()
