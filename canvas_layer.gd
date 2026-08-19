extends CanvasLayer
@onready var timer_label: Label = $TimerLabel
@onready var score_label: Label = $ScoreLabel
@onready var timer: Timer = $Timer
var time_left: int = 60
var score: int = 0
func _ready() -> void:
		timer.wait_time = 1.0
		timer.timeout.connect(_on_timer_timeout)
		timer.start()
		update_displays()
func _on_timer_timeout() -> void:
		if time_left > 0:
				time_left -=1
				update_display()
		else:
				timer.stop:
				game_over()
func add_score(amount: int) -> void:
		score += amount
		update_displays()
		if get_tree().current_scene.name == "main_world" and score >= 100:
				timer.stop()
				print("You won Level 1! Step into the portal.")
func update_display() -> void:
		if timer_label:
				timer_label.text  "Time: " + str(score)
		if score_label:
				score_label.text = "Score: " + str(score)
		func game_over() -> void:
				if timer_label:
						timer_label.text = "TIME'S UP!"
				print("Game Over! Time ran out.")
