extends Camera3D

@export var player: CharacterBody3D
var camera: Camera3D

func _ready():
	camera = player.camera
	get_parent().size = DisplayServer.window_get_size()
	#var outline_mask = load("res://Materials/WhiteOutlineMask.tres")
	load("res://Materials/WhiteOutline.tres") \
	.set_shader_parameter("mask", get_parent().get_texture())
	

func _process(_delta):
	global_position = camera.global_position
	global_rotation = camera.global_rotation
