class_name ToolPart
extends CollisionShape3D

@export var base: Area3D:
	set(value):
		base = value
		update_configuration_warnings()

@export var attachment_points: Array[Area3D]
@export var mesh: MeshInstance3D:
	set(value):
		mesh = value
		update_configuration_warnings()

func _get_configuration_warnings():
	var warnings := PackedStringArray()
	if mesh == null:
		warnings.append("Missing mesh")
	if base == null:
		warnings.append("Missing base area")
