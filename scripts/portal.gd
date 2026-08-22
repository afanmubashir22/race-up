extends Area3D
@export var target_scene: String = "res://parkour_world.scn"
var is_unlocked: bool = false
func _ready() -> void:
		body_entered.connect(_on_body_entered)
func unlock() -> void:
		is_unlocked = true
		print("Portal is now OPEN! ")
func _on_body_entered(body: Node) -> void:
		if body.has_method("die"):
				if is_unlocked:
						print("Player stepped into portal! Teleporting...")
						get_tree().call_deferred("change_scene_to_file", target_scene)
				else:
						print("Portal is LOCKED! Reach 100 points first.")
