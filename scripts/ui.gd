extends CanvasLayer

class_name UI

@onready var points_label: Label = $MarginContainer/PointsLabel

var points = 0  # Store the global points value

func _ready():
	# Initialize the points label to 0 when the game starts
	points_label.text = "%d" % points

# Update the points label when points change
func update_points(new_points: int):
	points = new_points  # Set global points
	points_label.text = "%d" % points  # Update the label
	print("Updated points: ", points)  # Debugging output
