extends Node2D

#preloads ground scene (res:// represents root directory of project)
const GROUND_SCENE = preload("res://Scenes/Ground/Ground.tscn")
#New ground spawns every 168 pixels
const GROUND_WIDTH = 504
#amount of grounds to fill gap so when bird flaps along screen the previous ground is deleted once out of view while another ground is in view
const AMOUNT_FILL_VIEW = 2

func _ready():
	#loops and creates ground for user to see (field of view)
	for i in range(AMOUNT_FILL_VIEW):
		spawn_and_move()

#calls and wraps both spawn_ground() and next_position() functions
func spawn_and_move():
	spawn_ground()
	next_position()

#ground spawns
func spawn_ground():
	#create ground as object node
	var new_ground = GROUND_SCENE.instance()
	#set position of new ground to spawner position (0,1024)
	new_ground.position = position
	#infinte ground is created
	#connect signal destroyed from ground scene to spawn_and_move method
	#when signal is emitted and connected function is called
	new_ground.connect("destroyed", self, "spawn_and_move")
	#add node to container node, position of child node of container won't be realtive to anything (position won't be based on another position)
	get_node("Container").call_deferred("add_child", new_ground)

#ground spawner moves across to end of x position from the previous ground to create a new one
func next_position():
	#spawner position is always the initial position.x + GroundWidth
	position = position + Vector2(GROUND_WIDTH, 0)
