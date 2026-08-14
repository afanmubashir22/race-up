extends CanvasLayer
@onready var timer_label: Label = $TimerLabel
@onready var timer: Timer = $Timer

var time_left: int = 60

func _ready() -> void:
		timer.timeout.connect(_on_timer_timeout)
		update_timer_display()
func _on_timer_timeout() -> void:
		if time_left > 0:
				time_left -= 1
				update_timer_display()
		else:
				timer.stop()
				game_over()
func update_timer_display() -> void:
		timer_label.text = "Time: " + str(time_left)
func game_over() -> void:
		timer_label.text = "TIME'S UP!"
		print("Game Over! Final score reached.")
