extends RigidBody3D
class_name GrabbableBody

@export var FORCE_MUL: float = 10

var move_target: Node3D = null

func set_move_target(target: Node3D):
	move_target = target
	lock_rotation = true

func remove_move_target():
	move_target = null
	lock_rotation = false

func move_toward_target(state: PhysicsDirectBodyState3D, _current_transform: Transform3D, target_position: Vector3):
	var move_dir = target_position - global_position
	state.set_linear_velocity(move_dir * FORCE_MUL)
	
func _integrate_forces(state):
	if move_target != null:
		move_toward_target(state, global_transform, move_target.global_position)
