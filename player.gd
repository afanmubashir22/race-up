extends CharacterBody3D

@export var SPEED: float  =  5.0
@export var JUMP_VELOCITY: float = 4.5
@export var MOUSE_SENSITIVITY: float = 0.003

@onready var camera: Camera3D = $Camera3D
@onready var shapecast: ShapeCast3D = $Camera3D/RayCast3D
@onready var carry_position: Marker3D = $Camera3D/CarryPosition

var held_item: RigidBody3D = null

func _ready() -> void:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if shapecast:
				shapecast.add_exception(self)
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
			velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	var input_dir := Vector2.ZERO
	if Input.is_key_pressed(KEY_W): input_dir.y -= 1
	if Input.is_key_pressed(KEY_S): input_dir.y += 1
	if Input.is_key_pressed(KEY_A): input_dir.x -= 1
	if Input.is_key_pressed(KEY_D): input_dir.x += 1
	input_dir = input_dir.normalized()
	
	var direction := (transform.basis * Vector3(input_dir.x, 0,input_dir.y)).normalized()
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
		if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
						Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				else:
						Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
				camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		if Input.is_key_pressed(KEY_E) and event.is_pressed() and not event.is_echo():
				if held_item == null:
						try_pickup_item()
				else:
						drop_item()
func try_pickup_item() -> void:
		if shapecast and shapecast.is_colliding():
				var collider = shapecast.get_collider(0)
				print("Shapecast hit: ", collider)
				if collider and collider.is_in_group("pickable") and collider is RigidBody3D:
						held_item = collider
						held_item.freeze = true
						var collision_shape = held_item.get_node_or_null("CollisionShape3D")
						if collision_shape:
								collision_shape.disabled = true
						print("Successfully picked up: ", held_item.name)
func drop_item() -> void:
		if held_item:
				var collision_shape = held_item.get_node_or_null("CollisionShape3D")
				if collision_shape:
						collision_shape.disabled = false
				held_item.freeze = false
				print("Dropped: ", held_item.name)
				held_item = null
		
