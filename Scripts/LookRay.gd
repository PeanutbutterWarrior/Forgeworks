extends RayCast3D

func _ready():
	add_exception(get_parent().get_parent())

var prev_seen: Object = null
func _physics_process(delta):
	if get_collider() != prev_seen:
		if prev_seen != null:
			SignalBus.stopped_looking_at.emit(prev_seen)
		prev_seen = get_collider()
		if is_colliding():
			SignalBus.looking_at.emit(get_collider())

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
			SignalBus.clicked_on.emit(get_collider())
