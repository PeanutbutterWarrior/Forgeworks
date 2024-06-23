extends ToolPart

@export var metal_type: Metal.MetalType
	
func _ready():
	var material
	match metal_type:
		Metal.MetalType.IRON:
			material = load("res://Materials/Iron.tres")
		Metal.MetalType.COPPER:
			material = load("res://Materials/Copper.tres")
	$Mesh.material_override = material
