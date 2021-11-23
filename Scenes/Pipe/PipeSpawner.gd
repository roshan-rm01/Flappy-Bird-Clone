extends Node2D

const PIPE_SCENE = preload("res://Scenes/Pipe/Pipe.tscn")
#width of pipe
const PIPE_WIDTH = 78
#vertical offset for pipe spawner
const OFFSET_Y = 320
 
#height of ground
const GROUND_HEIGHT = 168
#horizontal offset for next pipe
const OFFSET_X = 300
#amount of pipes is 3 to fill users view 
const AMOUNT_TO_FILL_VIEW = 3
 
func _ready():
	var bird = get_parent().get_node("Bird")
	#if there is a bird connect state changed signal 
	if bird:
	#	#CONNECT_ONESHOT disconnect signal once after emitted
		bird.connect("state_changed", self, "_on_Bird_state_changed", [], CONNECT_ONESHOT)
	else:
		return

#function gets called once signal is emitted (when state changes)
func _on_Bird_state_changed(bird):
	#if bird is flapping spawn pipes
	if bird.get_state() == bird.STATE_FLAPPING:
		start()

func start():
	#spawns initial pipe
	go_init_position()
	
	for i in range(AMOUNT_TO_FILL_VIEW):
		#constantly spawns 3 pipes for user to see as camera moves
		spawn_and_move()

#set spawner position
func go_init_position():
	#changes seed so theres a new random number every time
	randomize()
	var init_position = Vector2()
	#initial pipe position = view size width + half width size of pipe
	init_position.x = get_viewport_rect().size.x + PIPE_WIDTH / 2
	#y position of spawner is between a range from 0 to offset and minus ground height and minus offset
	init_position.y = rand_range(0+OFFSET_Y, get_viewport_rect().size.y-GROUND_HEIGHT-OFFSET_Y)
	#get camera node
	var camera = get_parent().get_node("Camera")
	#if theres a camera increase pipe position spawner with the camera offset 
	if camera:
		init_position.x += camera.get_total_position().x
	#set initial position of spawner
	position = init_position

#calls both functions 
func spawn_and_move():
	spawn_pipe()
	next_position()

#spawn pipe
func spawn_pipe():
	#create pipe instance
	var new_pipe = PIPE_SCENE.instance()
	#position of pipe is same as pipe spawner
	new_pipe.position = position
	#spawn new pipes when tree exited signal is emitted
	new_pipe.connect("destroyed", self, "spawn_and_move")
	#add new instance to container node (similar to ground spawner)
	get_node("Container").call_deferred("add_child", new_pipe)

#spawn next pipe 
func next_position():
	#changes seed so theres a new random number every time
	randomize()
	#next position is always relative to current position
	var next_position = position
	#next pipe position = half pipe width + offset + half of pipe width is always added on 
	next_position.x += PIPE_WIDTH/2 + OFFSET_X + PIPE_WIDTH/2
	#y position of spawner is between a range from 0 to offset and minus ground height and minus offset
	next_position.y = rand_range(0+OFFSET_Y, get_viewport_rect().size.y-GROUND_HEIGHT-OFFSET_Y)
	#set next position of spawner
	position = next_position

