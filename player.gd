extends CharacterBody3D

@export var SPEED: float  =  8.0
@export var JUMP_VELOCITY: float = 4.5
@export var MOUSE_SENSITIVITY: float = 0.003

@onready var camera: Camera3D = $Camera3D
@onready var shapecast: ShapeCast3D = $Camera3D/RayCast3D
@onready var carry_position: Marker3D = $Camera3D/CarryPosition

@onready var game_over_panel: Control = find_child("GameOverPanel", true, false)
@onready var final_score_label: Label = find_child("FinalScoreLabel", true, false)
@onready var restart_button: Button = find_child("RestartButton", true, false)

@onready var time_label: Label = find_child("TimeLabel", true, false)
@onready var score_label: Label = find_child("ScoreLabel", true, false)
@onready var timer: Timer = find_child("	Timer", true, false)
var held_item: RigidBody3D = null
var score: int = 0

func _ready() -> void:
		if game_over_panel:
				game_over_panel.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if shapecast:
				shapecast.add_exception(self)
		if restart_button:
				restart_button.pressed.connect(_on_restart_pressed)
		if timer:
				timer.timeout.connect(_on_game_over)
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
func _process(_delta: float) -> void:
		if timer and time_label:
				time_label.text = "Time: " + str(ceil(timer.time_left))
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
func _on_game_over() -> void:
		var hud_score = score_label
		if hud_score:
				final_score_label.text = "Final Score: " + hud_score.text.replace("Score: ", "")
		else:
				final_score_label.text = "Final Score: " + str(score)
		if game_over_panel:
				game_over_panel.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
func _on_restart_pressed() -> void:
		get_tree().paused = false
		get_tree().reload_current_scene()
func die() -> void:
		get_tree().call_deferred("reload_current_scene")
