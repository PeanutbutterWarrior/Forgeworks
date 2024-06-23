extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MAX_THROW_TIME = 0.75  # seconds
const THROW_FORCE = 15
const THROW_DIRECTION = Vector3(0, 0, -1)
const PULL_POINT_OFFSET = Vector3(0, 0, 0.5)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera := $Camera
@onready var ray := $Camera/LookRay
@onready var hold_point : Node3D = $Camera/HoldPoint
@onready var HOLD_POINT_POSITION = $Camera/HoldPoint.position

var held_object : GrabbableBody = null
var hold_timer : float = 0;

func _ready():
	SignalBus.connect("object_taken", _on_object_taken)

func _on_object_taken(obj: GrabbableBody, by: Object):
	if by == self:
		return
	if obj == held_object:
		held_object.remove_move_target()
		held_object = null

func grab_object(obj: GrabbableBody):
	SignalBus.object_taken.emit(obj, self)
	held_object = obj
	held_object.reparent(hold_point, true)
	held_object.set_move_target(hold_point)

func drop_object():
	held_object.reparent(get_tree().current_scene, true)
	held_object.remove_move_target()
	held_object = null

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, -PI / 2 + 0.01, PI / 2 - 0.01)
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
				if ray.get_collider() is AttachmentPoint and held_object is Tool:
					ray.get_collider().get_parent().get_parent().get_parent().add_tool(held_object, ray.get_collider())
				elif held_object != null:
					drop_object()
				elif ray.get_collider() is GrabbableBody:
					grab_object(ray.get_collider())
			elif event.button_index == MOUSE_BUTTON_RIGHT and !event.pressed and held_object != null:
				hold_point.position = THROW_DIRECTION
				var throw_direction: Vector3 = camera.global_position.direction_to(hold_point.global_position)
				held_object.apply_central_impulse(throw_direction * lerp(0, THROW_FORCE, hold_timer))
				hold_point.position = HOLD_POINT_POSITION
				hold_timer = 0
				drop_object()
	
	if event is InputEventKey and event.key_label == KEY_B:
		breakpoint
				
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and held_object != null:
		hold_timer += delta / MAX_THROW_TIME
		hold_timer = clamp(hold_timer, 0, 1)
		hold_point.position = HOLD_POINT_POSITION.lerp(HOLD_POINT_POSITION + PULL_POINT_OFFSET, hold_timer)

	move_and_slide()
