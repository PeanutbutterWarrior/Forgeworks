class_name Tool
extends GrabbableBody

@export var base_piece: ToolPart

@onready var white_outline := $WhiteOutline

static var scene := preload("res://Scenes/Tools/Tool.tscn")

static func create_with(obj: ToolPart) -> Tool:
	var tool: Tool = scene.instantiate()
	tool.base_piece = obj
	tool.add_child(obj)
	obj.position = Vector3.ZERO
	obj.rotation = Vector3.ZERO
	tool.get_child(0, true).add_mesh(obj.mesh)
	return tool

func _ready():
	for child in get_children():
		if child is ToolPart:
			white_outline.add_mesh(child.mesh)

func add_tool(tool: Tool, attach_point: Area3D):
	SignalBus.object_taken.emit(tool, self)
	tool.global_rotation = attach_point.global_rotation
	var base_point_offset = tool.global_position - tool.base_piece.base.global_position
	tool.global_position = attach_point.global_position + base_point_offset
	
	for part in tool.get_children():
		if part is ToolPart:
			part.reparent(self)
			white_outline.add_mesh(part.mesh)
		
	tool.queue_free()

func set_base_piece(obj):
	base_piece = obj
