extends RigidBody2D

enum SpawnLocation {TOP, BOTTOM, LEFT, RIGHT}

var rng: RandomNumberGenerator
var screen_size: Vector2

func _ready():
	hide()
	rng = RandomNumberGenerator.new()
	screen_size = get_viewport_rect().size

# spawn mob at a random position
func spawn():
	var spawn_location = _get_spawn_location()
	position = _get_random_position(spawn_location)
	show()

func _get_spawn_location():
	return SpawnLocation[rng.randi_range(0, 3)]

func _get_random_position(spawn_location: int):
	var random_position = Vector2()
	match spawn_location:
		SpawnLocation.TOP:
			random_position.x = rng.randi_range(0, screen_size.x)
			random_position.y = 0
		SpawnLocation.BOTTOM:
			random_position.x = rng.randi_range(0, screen_size.x)
			random_position.y = screen_size.y
		SpawnLocation.LEFT:
			random_position.x = 0
			random_position.y = rng.randi_range(0, screen_size.y)
		SpawnLocation.RIGHT:
			random_position.x = screen_size.x
			random_position.y = rng.randi_range(0, screen_size.y)
