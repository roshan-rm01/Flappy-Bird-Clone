extends StaticBody2D

#get position2d node when scene tree is about to start
onready var right = get_node("Right")
#get camera node when scene tree is about to start
onready var camera = get_tree().get_root().get_node("GameStage").get_node("Camera")

signal destroyed

func _ready():
	#add pipe to a group
	add_to_group("Pipes")

func _process(delta):
	#code won't run if camera is non existent
	if camera == null:
		return
	#(get_global_position used to get exact position of position2D at end of pipe)
	#if camera position >= Position2d, delete pipe
	#need to adjust camera offset with pipe spawning so get_total_position() is used
	if right.get_global_position().x <= camera.get_total_position().x:
		queue_free() 
		emit_signal("destroyed")