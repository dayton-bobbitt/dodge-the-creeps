extends Area2D

signal hit

# player's speed in pixels/second
# using "export" allows us to set the value in the inspector
export var speed: int = 400

# size of the game window
var screen_size: Vector2

# distance from center of player to top / side of head
var player_width: int
var player_height: int


func start(starting_position: Vector2):
	position = starting_position
	show()
	$CollisionShape2D.disabled = false


func _ready():
	hide()
	screen_size = get_viewport_rect().size
	player_width = $CollisionShape2D.shape.radius
	player_height = $CollisionShape2D.shape.height / 2 + $CollisionShape2D.shape.radius


func _process(delta: float):
	var velocity = _get_player_velocity()
	_move_player(velocity, speed, delta)
	_animate_player(velocity)


func _on_Player_body_entered(_body: Node):
	hide() # hide player after being hit
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func _get_player_velocity():
	# player's movement vector
	var velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	if velocity.length() > 0:
		return velocity.normalized()
	else:
		return velocity


func _move_player(velocity: Vector2, player_speed: int, delta: float):
	if velocity.length() > 0:
		var movement = velocity * player_speed
		position += movement * delta
		
		if velocity.x != 0 and velocity.y != 0:
			# player is moving diagonally; clamp based on width
			position.x = clamp(position.x, player_width, screen_size.x - player_width)
			position.y = clamp(position.y, player_width, screen_size.y - player_width)
		else:
			position.x = clamp(position.x, player_height, screen_size.x - player_height)
			position.y = clamp(position.y, player_height, screen_size.y - player_height)


func _animate_player(velocity: Vector2):
	if velocity.length() == 0:
		# reset to first frame to close "legs"
		$AnimatedSprite.frame = 0
		$AnimatedSprite.stop()
	else:
		if velocity.y != 0:
			$AnimatedSprite.flip_v = velocity.y > 0

			if velocity.x == 0:
				$AnimatedSprite.rotation_degrees = 0
			else:
				# e.g. when moving up and to the left, rotate -45deg because -45 * -1x * -1y
				# e.g. when moving up and to the right, rotate 45deg because -45 * 1x * -1y
				$AnimatedSprite.rotation_degrees = -45 * velocity.x * velocity.y
		elif velocity.x != 0:
			$AnimatedSprite.flip_v = false
			$AnimatedSprite.rotation_degrees = 90 * velocity.x

		$AnimatedSprite.play()

