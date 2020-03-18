extends RigidBody2D

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


func _process(delta):
	position += direction * speed * delta


func _on_start_game():
	queue_free()


func _on_Visibility_screen_entered():
	$AnimatedSprite.play()


func _on_Visibility_screen_exited():
	queue_free()


# spawn mob at a random position and move towards player
func spawn(spawn_location: Vector2, player_position: Vector2):
	position = spawn_location
	direction = position.direction_to(player_position)
	
	# rotate mob to face the player
	rotation = direction.angle()
	show()
