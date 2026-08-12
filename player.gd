extends CharacterBody3D
@export var speed: float = 5.0
@export var mouse_sensitivity: float =0.003
@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var carry_position: Marker3D = $Camera3D/CarryPostion
var held_object: RigidBody3D = null
func _ready() -> void:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseMotion:
				rotate_y(-event.relative.x * mouse_sensitivity)
				camera.rotate_x(-event.relative.y * mouse_sensitivity)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		if event.is_action_pressed("ui_cancel"):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event.is_action_pressed("interact"):
				if held_object:
						_drop_item()
				else:
						_pick_item()
func _physics_process(_delta: float) -> void:
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
				velocity.x = dir
