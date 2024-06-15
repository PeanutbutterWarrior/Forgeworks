class_name WhiteOutline
extends Node

@export var mesh: MeshInstance3D
@export var collider: CollisionObject3D
var outline_mat := preload("res://Materials/WhiteOutline.tres")

func _ready():
	SignalBus.connect("looking_at", _on_look)
	SignalBus.connect("stopped_looking_at", _on_look_away)

func _on_look(obj: Object):
	if obj == null or obj == collider:
		mesh.material_overlay = outline_mat

func _on_look_away(obj: Object):
	if obj == null or obj == collider:
		mesh.material_overlay = null
