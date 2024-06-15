extends Node3D

@onready var anchor_point = $AnchorPoint
@onready var collider = $Collider
@onready var grab_area = $GrabArea

var anchored_object: GrabbableBody = null

static var metal_pill := preload("res://Scenes/MetalPill.tscn")

func _ready():
	SignalBus.connect("clicked_on", _on_click)
	SignalBus.connect("object_taken", _on_object_taken)

func hold_object(obj: GrabbableBody):
	SignalBus.object_taken.emit(obj, self)
	anchored_object = obj
	obj.move_target = null
	obj.reparent(anchor_point)
	obj.rotation = Vector3.ZERO
	obj.position = Vector3(0, obj.scale.y / 2, 0)
	obj.freeze = true

func craft():
	var metal_type = anchored_object.metal_type
	anchored_object.queue_free()
	var new_obj := metal_pill.instantiate()
	new_obj.metal_type = metal_type
	anchor_point.add_child(new_obj)
	hold_object(new_obj)

func _on_click(obj: Object):
	if obj == grab_area or obj == collider:
		if anchored_object is MetalBar:
			craft()

func _on_grab_area_body_entered(body: Node3D):
	if body == anchored_object:
		return
	
	if body is MetalBar:
		hold_object(body)

func _on_object_taken(obj: GrabbableBody, by: Object):
	if by == self:
		return
	if obj == anchored_object:
		anchored_object.freeze = false
		anchored_object = null
