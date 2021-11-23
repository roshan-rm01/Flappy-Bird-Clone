extends StaticBody2D

#get position2D node
onready var bottom_right = get_node("BottomRight")
#get camera node
onready var camera = get_tree().get_root().get_node("GameStage").get_node("Camera")
#creates signal to destroy ground that is out of camera view
#exit tree built in signal can be used as well 
signal destroyed

func _ready():
	#add ground to group
	add_to_group("Ground")

#called every frame
func _process(delta):
	#code won't run if camera is non existent
	if camera == null:
		return
	#(get_global_position used to get exact position of position2D at end of ground)
	#if camera position >= Position2d, delete ground
	#need to adjust camera offset with ground spawning so get_total_position() is used
	if bottom_right.get_global_position().x <= camera.get_total_position().x:
		queue_free()
	#	#when position2D <= camera position.x signal destroyed is emitted which calls following functions from spawnerGround script spawn_ground(), next_position() 
		emit_signal("destroyed")
