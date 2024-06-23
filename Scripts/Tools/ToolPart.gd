class_name ToolPart
extends CollisionShape3D

@export var base: Area3D:
	set(value):
		base = value
		update_configuration_warnings()

var attachment_points: Array[Area3D]
var meshes: Array[MeshInstance3D]

func _ready():
	for child in get_children():
		if child is MeshInstance3D:
			meshes.append(child)
		elif child is Area3D:
			attachment_points.append(child)

func _get_configuration_warnings():
	var warnings := PackedStringArray()
	if base == null:
		warnings.append("Missing base area")
