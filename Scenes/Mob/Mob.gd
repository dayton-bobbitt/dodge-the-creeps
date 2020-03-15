extends RigidBody2D

enum SpawnLocation {TOP, BOTTOM, LEFT, RIGHT}

var rng: RandomNumberGenerator
var screen_size: Vector2

# mob speed in pixels/second
export var speed = 250

# indicates whether or not the mob has spawned
var spawned = false

# vector from mob's position to player
var direction: Vector2

# offset used to ensure the mob spawns off-screen
var offset: float

# used to determine when the mob should be removed
var has_entered_viewport = false

func _ready():
	hide()
	rng = RandomNumberGenerator.new()
	rng.randomize()
	screen_size = get_viewport_rect().size
	offset = $CollisionShape2D.shape.radius * 4

func _process(delta):
	if spawned:
		position += direction * speed * delta

# spawn mob at a random position and move towards player
func spawn(player_position: Vector2):
	if !spawned:
		var spawn_location = _get_spawn_location()
		position = _get_random_position(spawn_location)
		direction = position.direction_to(player_position)
		
		# rotate mob to face the player
		rotation = direction.angle()
		spawned = true
		show()

func _get_spawn_location():
	var random_index = rng.randi_range(0, SpawnLocation.size() - 1)
	return SpawnLocation.values()[random_index]

func _get_random_position(spawn_location: int):
	var random_position = Vector2()
	match spawn_location:
		SpawnLocation.TOP:
			random_position.x = rng.randi_range(0, screen_size.x as int)
			random_position.y = -offset
		SpawnLocation.BOTTOM:
			random_position.x = rng.randi_range(0, screen_size.x as int)
			random_position.y = screen_size.y + offset
		SpawnLocation.LEFT:
			random_position.x = -offset
			random_position.y = rng.randi_range(0, screen_size.y as int)
		SpawnLocation.RIGHT:
			random_position.x = screen_size.x + offset
			random_position.y = rng.randi_range(0, screen_size.y as int)
	return random_position
