extends Node2D

# Exported variables for configuration
@export var object_scene: PackedScene = preload("res://scenes/kutsekakaart_coin.tscn")  # The scene to spawn
@export var spawn_interval: float = randf_range(3, 5)  # Time in seconds between spawns
@export var spawn_position_y_range: Vector2 = Vector2(-5, 10)  # Y-range for spawning
@export var spawn_position_x: float = 800  # X-position off the screen (right side)
@export var despawn_x: float = -800  # X-position to despawn objects (left side)
@export var speed: float = -250  # Speed at which objects move to the left

# Timer for spawning
@onready var spawn_timer: Timer = Timer.new()

# Store active objects in an array
var active_objects: Array = []

func _ready():
	# Validate the object scene
	if object_scene == null:
		print("Error: No object scene assigned to Spawner.")
		return

	# Configure and add the spawn timer
	spawn_timer.wait_time = spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_spawn_object"))
	add_child(spawn_timer)
	spawn_timer.start()

	print("Spawner initialized. Spawning every ", spawn_interval, " seconds.")

func _process(delta):
	# Move all active objects to the left
	for obj in active_objects:
		obj.global_position.x += speed * delta

		# Check if the object is off the screen to the left
		if obj.global_position.x < despawn_x:
			_despawn_object(obj)

func _spawn_object():
	# Validate the object scene
	if object_scene == null:
		print("Error: No object scene assigned to Spawner.")
		return

	# Instantiate the object
	var obj = object_scene.instantiate()
	add_child(obj)

	# Set the initial spawn position (off the screen to the right)
	var spawn_y = randf_range(spawn_position_y_range.x, spawn_position_y_range.y)
	obj.global_position = Vector2(spawn_position_x, spawn_y)

	# Add to active objects
	active_objects.append(obj)

	# Debugging output
	print("Spawned object at: ", obj.global_position)

	# Connect signal to detect character collision (requires Area2D in object scene)
	if obj is Area2D:
		obj.connect("body_entered", Callable(self, "_on_object_touched").bind(obj))

func _despawn_object(obj):
	# Remove the object from the active list and free it
	if obj in active_objects:
		active_objects.erase(obj)
	obj.queue_free()
	print("Despawned object.")

func _on_object_touched(body, obj):
	# Check if the object was touched by the player
	if body.name == "player":  # Replace "player" with the name of your character node
		print("Object touched by player. Despawning.")
		_despawn_object(obj)
