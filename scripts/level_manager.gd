extends Node3D
var score: int = 0 
@export var total_needed: int = 14
func _ready() -> void:
		for child in get_children():
				if child is Area3D and child.name == "Shrine":
						child.connect("item_deposited", _on_item_deposited)
func _on_item_deposited(item_node: Node) -> void:
		score += 1
		item_node.queue_free()
		print("Score: ", score, "/", total_needed)
		var label = find_child("ScoreLabel", true, false)
		if label:
				label.text = "Score: " + str(score) + "/" + str(total_needed)
