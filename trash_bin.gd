extends Area3D
@export var accepts_type: String = "Trash"
static var score: int = 0
func _ready() -> void:
		body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node3D) -> void:
		if body is RigidBody3D and body.has_meta("item_type"):
				var type = body.get_meta("item_type")
				if type == accepts_type:
						score += 10
						_update_score_ui()
						body.queue_free()
				else:
						print("WRONG BIN!")
func _update_score_ui() -> void:
		var label = get_tree().root.find_child("Label", true, false)
		if label:
				label.text = "Score: " + str(score)
