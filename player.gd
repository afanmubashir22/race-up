extends CharacterBody3D
@export var SPEED: float = 5.0
@export var JUMP_VELOCITY : float = 4.5
@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var carry_position: Marker3D = $Camera3D/CarryPosition
var held_item: RigidBody3D = null
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
func _physics_process(delta: float) -> void:
		if not is_on_floor():
				velocity += get_gravity() * delta
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
		else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
		if held_item:
				held_item.global_transform.origin = carry_position.global_transform.origin
func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				rotate_y(deg_to_rad(-event.relative.x * 0.15))
				camera.rotate_x(deg_to_rad(-event.relative.y * 0.15))
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		if Input.is_action_just_pressed("interact"):
			if held_item == null:
					try_pickup_item()
			else:
					drop_item()
func  try_pickup_item() -> void:
		var collider = raycast.get_collider()
		print("Raycast hit object: ", collider)
		if collider and collider.is_in_group("pickable") and collider is RigidBody3D:
				held_item = collider
				held_item.freeze = true
				print("Successfully picked up: ", held_item.name)
func drop_item() -> void:
		if held_item:
				held_item.freeze = false
				print("Dropped item: ", held_item.name)
				held_item = null
