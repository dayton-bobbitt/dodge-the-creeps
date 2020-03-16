extends RigidBody2D

enum SpawnLocation {TOP, BOTTOM, LEFT, RIGHT}

var screen_size: Vector2

# mob speed in pixels/second
export var min_speed = 150
export var max_speed = 250
var speed: int

# vector from mob's position to player
var direction: Vector2

# offset used to ensure the mob spawns off-screen
var offset: float

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	offset = $CollisionShape2D.shape.radius * 4
	speed = randi() % max_speed + min_speed
	$VisibilityNotifier2D.connect("screen_entered", self, "_on_Visibility_screen_entered")
	$VisibilityNotifier2D.connect("screen_exited", self, "_on_Visibility_screen_exited")

func _process(delta):
	position += direction * speed * delta

func _on_Visibility_screen_entered():
	$AnimatedSprite.play()

func _on_Visibility_screen_exited():
	queue_free()

# spawn mob at a random position and move towards player
func spawn(player_position: Vector2):
	var spawn_location = _get_spawn_location()
	position = _get_random_position(spawn_location)
	direction = position.direction_to(player_position)
	
	# rotate mob to face the player
	rotation = direction.angle()
	show()

func _get_spawn_location():
	return SpawnLocation.values()[randi() % SpawnLocation.size()]

func _get_random_position(spawn_location: int):
	var random_position = Vector2()
	match spawn_location:
		SpawnLocation.TOP:
			random_position.x = randi() % (screen_size.x as int)
			random_position.y = -offset
		SpawnLocation.BOTTOM:
			random_position.x = randi() % (screen_size.x as int)
			random_position.y = screen_size.y + offset
		SpawnLocation.LEFT:
			random_position.x = -offset
			random_position.y = randi() % (screen_size.y as int)
		SpawnLocation.RIGHT:
			random_position.x = screen_size.x + offset
			random_position.y = randi() % (screen_size.y as int)
	return random_position
