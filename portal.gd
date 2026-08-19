extends Area3D
@export var target_scene: String = "res://parkour_world.scn"
func _ready() -> void:
		body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node):
		if body.has_method("die") :
				print("Player stepped into portal! Teleporting...")
				get_tree().call_deferred("change_scene_to_file", target_scene)
		
