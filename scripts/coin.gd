extends Area2D

# Adjust the path to match your scene structure
@onready var ui: UI = get_node("/root/Game/UI") as UI  # Correct path to the UI node
@onready var pickup: AudioStreamPlayer2D = get_node("/root/Game/kutsekakaart_coin/pickup")

func _ready():
	# Ensure the Area2D is set to trigger on collisions
	self.monitoring = true
	self.visible = true  # Ensure the object is visible initially

# This method is called when the player collides with the object
func _on_body_entered(body):
	# Debugging the touch
	print("Object touched by: ", body.name)
	
	if body.name == "player":  # Assuming the player's node name is "Player"
		print("Points before update: ", ui.points)  # Debugging output for current points
		ui.update_points(ui.points + 1)  # Increment the global points in the UI script
		visible = false  # Make the object invisible
		print("Object touched by player. Despawning.")
		_despawn_object()  # Despawn the object after collection
	else:
		print("Wrong player name")

# Reset the object to a spawnable position
func _despawn_object():
	# Reset the object position off-screen
	visible = true  # Make the object visible again for future collection
	self.global_position = Vector2(800, randf_range(-5, 10))  # Move it off the screen (right side)
	
