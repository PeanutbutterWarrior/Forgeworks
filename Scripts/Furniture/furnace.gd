extends Node3D

static var MetalBarPacked := preload("res://Scenes/Ingredients/MetalBar.tscn")

@onready var drop_point := $BarDrop
@onready var drop_timer := $DropTimer

var metal: Metal.MetalType = Metal.MetalType.IRON

func _on_ore_collection_body_entered(body):
	if body is Ore:
		metal = body.get_metal_type()
		body.queue_free()
		drop_timer.start()

func _drop_timer():
	var bar = MetalBarPacked.instantiate()
	bar.metal_type = metal
	get_tree().current_scene.add_child(bar)
	bar.global_position = drop_point.global_position
