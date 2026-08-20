extends CanvasLayer
@onready var timer_label: Label = get_node_or_null("TimerLabel")
@onready var score_label: Label = get_node_or_null("ScoreLabel")
@onready var timer: Timer = get_node_or_null("Timer")
var time_left: int = 90
var score: int = 0
var is_game_over: bool = false
func _ready() -> void:
		var current_scene_name = get_tree().current_scene.name.to_lower()
		if timer:
				if timer.timeout.is_connected(_on_timer_timeout):
						timer.timeout.disconnect(_on_timer_timeout)
				timer.timeout.connect(_on_timer_timeout)
				timer.wait_time = 1.0
				timer.one_shot = false
				if "main" in current_scene_name:
						timer.start()
						if timer_label:
								timer_label.show()
				else:
						timer.stop()
						if timer_label:
								timer_label.hide()
		update_display()
func _on_timer_timeout() -> void:
		if time_left > 0:
				time_left -=1
				update_display()
		else:
				if timer:
						timer.stop()
				game_over()
func add_score(amount: int) -> void:
		if is_game_over:
				return
		score += amount
		update_display()
func update_display() -> void:
		var scene_name = get_tree().current_scene.name.to_lower()
		if timer_label:
				if "main" in scene_name:
						timer_label.text = "Time: " +  str(time_left)
				else:
						timer_label.hide()
		if score_label:
				score_label.text = "Score: " + str(score)
func game_over() -> void:
		is_game_over = true
		if timer_label:
				timer_label.text = "TIME'S UP!"
		print("Game Over! Time ran out.")
