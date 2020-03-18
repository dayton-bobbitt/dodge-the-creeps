extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func _hide_message():
	$MessageLabel.hide()


func update_score(score):
	$ScoreLabel.text = str(score)


func show_game_over():
	show_message("Game Over.")
	yield($MessageTimer, "timeout")
	
	$MessageLabel.text = "Dodge the Creeps!"
	$MessageLabel.show()
	
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func _start_game():
	$StartButton.hide()
	emit_signal("start_game")
