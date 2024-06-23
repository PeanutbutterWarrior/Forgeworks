class_name Tool
extends GrabbableBody

@export var base_piece: ToolPart:
	set(value):
		base_piece = value
		update_configuration_warnings()

@onready var white_outline := $WhiteOutline

static var scene := preload("res://Scenes/Tools/Tool.tscn")

static func create_with(obj: ToolPart) -> Tool:
	var tool: Tool = scene.instantiate()
	tool.base_piece = obj
	tool.add_child(obj)
	obj.position = Vector3.ZERO
	obj.rotation = Vector3.ZERO
	return tool

func _get_configuration_warnings():
	if base_piece == null:
		return ["Missing base piece"]
	else:
		return []

func _ready():
	for child in get_children():
		if child is ToolPart:
			for mesh in child.meshes:
				white_outline.add_mesh(mesh)

func add_tool(tool: Tool, attach_point: Area3D):
	SignalBus.object_taken.emit(tool, self)
	tool.global_rotation = attach_point.global_rotation
	var base_point_offset = tool.global_position - tool.base_piece.base.global_position
	tool.global_position = attach_point.global_position + base_point_offset
	
	for part in tool.get_children():
		if part is ToolPart:
			part.reparent(self)
			for mesh in part.meshes:
				white_outline.add_mesh(mesh)
		
	tool.queue_free()
