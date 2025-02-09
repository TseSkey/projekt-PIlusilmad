extends Node2D

@export var speed = -250
@export var object_scene_1: PackedScene = preload("res://scenes/random_objects1.tscn")  # Preload your first object scene
@export var object_scene_2: PackedScene = preload("res://scenes/random_objects2.tscn")  # Preload your second object scene
@export var object_scene_3: PackedScene = preload("res://scenes/random_objects3.tscn")  # Preload your third object scene

@export var spawn_interval = randf_range(1, 2)   # Time (in seconds) between spawns

# Define a common X range for all objects
@export var x_range: Vector2 = Vector2(200, 300)  # Shared X range for all objects

# Define different Y ranges for each object
@export var spawn_range_1: Vector2 = Vector2(-20, -25)  # Y range for the first object
@export var spawn_range_2: Vector2 = Vector2(12, 12)  # Y range for the second object
@export var spawn_range_3: Vector2 = Vector2(11, 11)  # Y range for the third object

@onready var sprite1: Sprite2D = $ground1/Sprite2D
@onready var sprite2: Sprite2D = $ground2/Sprite2D

var object_pool_1: Array = []  # Array to store the first type of objects
var object_pool_2: Array = []  # Array to store the second type of objects
var object_pool_3: Array = []  # Array to store the third type of objects

func _ready():
	# Align ground tiles
	sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()

	# Instantiate and add multiple objects of each type to the pools
	for i in range(5):  # Spawn 5 of each object type
		var obj_1 = object_scene_1.instantiate()
		obj_1.visible = false
		add_child(obj_1)
		object_pool_1.append(obj_1)

		var obj_2 = object_scene_2.instantiate()
		obj_2.visible = false
		add_child(obj_2)
		object_pool_2.append(obj_2)

		var obj_3 = object_scene_3.instantiate()
		obj_3.visible = false
		add_child(obj_3)
		object_pool_3.append(obj_3)

	# Set up a spawn timer
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false  # Make it repeat
	spawn_timer.connect("timeout", Callable(self, "spawn_object"))
	add_child(spawn_timer)
	spawn_timer.start()

func _process(delta):
	# Scroll the ground
	sprite1.global_position.x += speed * delta
	sprite2.global_position.x += speed * delta

	# Loop through all objects in all pools
	for obj in object_pool_1:
		if obj.visible:
			obj.global_position.x += speed * delta  # Move the object with the ground speed
			if obj.global_position.x < -800:  # Adjust based on your screen size
				reset_object(obj, 1)

	for obj in object_pool_2:
		if obj.visible:
			obj.global_position.x += speed * delta  # Move the object with the ground speed
			if obj.global_position.x < -800:  # Adjust based on your screen size
				reset_object(obj, 2)

	for obj in object_pool_3:
		if obj.visible:
			obj.global_position.x += speed * delta  # Move the object with the ground speed
			if obj.global_position.x < -800:  # Adjust based on your screen size
				reset_object(obj, 3)

	# Handle ground scrolling
	if sprite1.global_position.x < -sprite1.texture.get_width():
		sprite1.global_position.x = sprite2.global_position.x + sprite2.texture.get_width()
	if sprite2.global_position.x < -sprite2.texture.get_width():
		sprite2.global_position.x = sprite1.global_position.x + sprite1.texture.get_width()

func spawn_object():
	# Randomly choose whether to spawn object 1, object 2, or object 3
	var random_choice = randi() % 3  # 0, 1, or 2

	if random_choice == 0:  # Spawn object 1
		spawn_single_object(object_pool_1, spawn_range_1)
	elif random_choice == 1:  # Spawn object 2
		spawn_single_object(object_pool_2, spawn_range_2)
	else:  # Spawn object 3
		spawn_single_object(object_pool_3, spawn_range_3)

func spawn_single_object(object_pool: Array, spawn_range: Vector2):
	# Randomly select an object from the pool
	var obj = object_pool[randi() % object_pool.size()]  # Random index

	# Set the object's position randomly within the common X range and specific Y range
	var x_position = randf_range(x_range.x, x_range.y)  # Shared X range
	var y_position = randf_range(spawn_range.x, spawn_range.y)  # Specific Y range
	obj.global_position = Vector2(x_position, y_position)

	# Make the object visible and "activate" it
	obj.visible = true

	# Debugging output
	print("Object spawned at: ", obj.global_position)

func reset_object(obj: Node2D, object_type: int):
	# Reset the object to its initial state
	obj.visible = false

	# Use the common X range and the specific Y range based on the object type
	var x_position = randf_range(x_range.x, x_range.y)  # Shared X range
	var y_position = 0  # Default value to be overwritten below

	if object_type == 1:  # Object 1 reset
		y_position = randf_range(spawn_range_1.x, spawn_range_1.y)
	elif object_type == 2:  # Object 2 reset
		y_position = randf_range(spawn_range_2.x, spawn_range_2.y)
	else:  # Object 3 reset
		y_position = randf_range(spawn_range_3.x, spawn_range_3.y)
		
	obj.global_position = Vector2(x_position, y_position)
	print("Object reset and repositioned to the right.")
