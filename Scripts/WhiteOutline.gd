class_name WhiteOutline
extends Node

@export var mesh: MeshInstance3D
@export var collider: CollisionObject3D
var outline_mat := preload("res://Materials/WhiteOutline.tres")
var mask_mat := preload("res://Materials/WhiteOutlineMask.tres")

var enabled = false
var submesh: MeshInstance3D

func _ready():
	SignalBus.connect("looking_at", _on_look)
	SignalBus.connect("stopped_looking_at", _on_look_away)
	
	submesh = MeshInstance3D.new()
	submesh.name = "OutlineMaskMesh"
	submesh.mesh = mesh.mesh.duplicate()
	submesh.mesh.surface_set_material(0, mask_mat)
	submesh.material_override = mask_mat
	submesh.layers = 2
	submesh.visible = false
	
	mesh.add_child(submesh)

func enable_outline():
	mesh.material_overlay = outline_mat
	enabled = true
	submesh.visible = true

func disable_outline():
	mesh.material_overlay = null
	enabled = false
	submesh.visible = false

func _on_look(obj: Object):
	if obj == null or obj == collider:
		enable_outline()

func _on_look_away(obj: Object):
	if obj == null or obj == collider:
		disable_outline()
