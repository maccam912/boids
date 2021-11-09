extends Sprite

export var center_of_mass = Vector2(0, 0)
export var velocity = Vector2(0, 0)
export var min_dist = 8

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var x = rng.randf_range(0.0, 1000.0)
	var y = rng.randf_range(0.0, 500.0)
	position = Vector2(x, y)
	x = rng.randf_range(-10.0, 10.0)
	y = rng.randf_range(-10.0, 10.0)
	velocity = Vector2(x, y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var to_center_of_mass = center_of_mass - position
	if position.x < 0 || position.y < 0 || position.x > get_viewport().size.x || position.y > get_viewport().size.y:
		velocity = velocity + 100*to_center_of_mass
	else:
		velocity = velocity + 0.1*to_center_of_mass

	velocity = velocity.clamped(100)
	rotation = velocity.angle()
	position += velocity*delta

func avoid_closest_neighbor(other_boid):
	if position.distance_to(other_boid.position) < min_dist:
		var dist = position.distance_to(other_boid.position)
		# Too close! Turn away
		var direction_to = position.direction_to(other_boid.position)
		var direction_away = direction_to * -1
		velocity += (100*direction_away) / dist

func match_closest_neighbor_direction(other_boid):
	if position.distance_to(other_boid.position) >= min_dist:
		# Far enough, lets change direction
		velocity += 0.2*other_boid.velocity
