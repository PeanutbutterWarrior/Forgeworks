@tool
class_name WhiteOutline
extends Node

@export var meshes: Array[MeshInstance3D]:
	set(value):
		meshes = value
		update_configuration_warnings()
@export var colliders: Array[CollisionObject3D]:
	set(value):
		colliders = value
		update_configuration_warnings()

var submeshes: Array[MeshInstance3D]
var outline_mat := preload("res://Materials/WhiteOutline.tres")
var mask_mat := preload("res://Materials/WhiteOutlineMask.tres")

var enabled = false

func _ready():
	SignalBus.connect("looking_at", _on_look)
	SignalBus.connect("stopped_looking_at", _on_look_away)
	
	for mesh in meshes:
		add_submesh(mesh)
		

func _get_configuration_warnings():
	var warning_array := PackedStringArray()
	if meshes.size() == 0 or null in meshes:
		warning_array.append("Missing mesh")
	if colliders.size() == 0 or null in meshes:
		warning_array.append("Missing collider")
	return warning_array

func add_mesh(mesh: MeshInstance3D):
	meshes.append(mesh)
	add_submesh(mesh)
	

func add_submesh(mesh: MeshInstance3D):
	var submesh = MeshInstance3D.new()
	submesh.mesh = mesh.mesh.duplicate()
	submesh.mesh.surface_set_material(0, mask_mat)
	submesh.material_override = mask_mat
	submesh.layers = 2
	submesh.visible = false
	mesh.add_child(submesh)
	submeshes.append(submesh)

func enable_outline():
	for mesh in meshes:
		mesh.material_overlay = outline_mat
	enabled = true
	for submesh in submeshes:
		submesh.visible = true

func disable_outline():
	for mesh in meshes:
		mesh.material_overlay = null
	enabled = false
	for submesh in submeshes:
		submesh.visible = false

func _on_look(obj: Object):
	if obj == null or obj in colliders:
		enable_outline()

func _on_look_away(obj: Object):
	if obj == null or obj in colliders:
		disable_outline()
