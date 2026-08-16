extends Node3D
@export var trash_scene: PackedScene
@export var recycle_scene: PackedScene
@onready var spawn_points: Node3D = $SpawnPoints
@onready var spawn_timer: Timer = $SpawnTimer
var active_spawns: Dictionary = {}

func _ready() -> void:
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		
func _on_spawn_timer_timeout() -> void:
		var points = spawn_points.get_children()
		if points.is_empty():
				return
		points.shuffle()
		for point in points:
				if not active_spawns.has(point) or not is_instance_valid(active_spawns[point]):
						var item_to_spawn = trash_scene if randf() > 0.5 else recycle_scene
						if item_to_spawn:
								var new_item = item_to_spawn.instantiate()
								add_child(new_item)
								new_item.global_position = point.global_position
								active_spawns[point] =new_item
								new_item.tree_exited.connect(func(): active_spawns.erase(point))
						return
