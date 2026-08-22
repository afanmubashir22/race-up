extends Area3D
@export var required_score: int = 90
@export var exit_delay_seconds:  float = 3.0
var has_triggered: bool = false

func _ready() -> void:
		body_entered.connect(_on_body_entered)
func _on_body_entered(body: Node) -> void:
		if has_triggered:
				return
		if body.has_method("die"):
				var canvas_layer = get_tree().root.find_child("CanvasLayer", true, false)
				if canvas_layer and "score" in canvas_layer:
						var current_score = canvas_layer.score
						if current_score >= required_score:
								has_triggered = true
								print("SHRINE ACTIVITED! YOU HAVE COMPLETED THE GAME!")
								win_game_final(canvas_layer)
						else:
								print("THE Shrine remains dormant. You need " + str(required_score) +  " points! (Current: " +str(current_score) + ")")
func win_game_final(canvas_layer: Node) -> void:
		var bgm_player = get_tree().root.find_child("BGMPlayer", true, false)
		if bgm_player:
				bgm_player.stop()
		if canvas_layer.has_node("TimerLabel"):
				var label = canvas_layer.get_node("TimerLabel")
				label.text = "GAME COMPLETED! CLOSING GAME..."
				label.show()
		await get_tree().create_timer(exit_delay_seconds).timeout
		get_tree().quit()
