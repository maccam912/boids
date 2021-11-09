extends Node2D

var boids_list = []

var boid_scene = preload("res://Boid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(200):
		var boid = boid_scene.instance()
		add_child(boid)
		boids_list += [boid]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var center_of_mass = get_center_of_mass()
	for b in boids_list:
		b.center_of_mass = center_of_mass
	for b in boids_list:
		var ns = get_nearest_boids(b)
		for n in ns:
			b.avoid_closest_neighbor(n)
			b.match_closest_neighbor_direction(n)

func get_center_of_mass():
	var center_of_mass = Vector2(0, 0)
	for b in boids_list:
		center_of_mass += b.position
	center_of_mass /= len(boids_list)
	return Vector2(clamp(center_of_mass.x, 100, get_viewport().size.x)-100, clamp(center_of_mass.y, 100, get_viewport().size.y)-100)

func get_nearest_boids(b):
	var min_dist = 14
	var neighbors = []
	for bb in boids_list:
		if bb.position != b.position and bb.position.distance_to(b.position) < min_dist:
			neighbors += [bb]
	return neighbors
