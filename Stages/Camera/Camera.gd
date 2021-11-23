extends Camera2D

#current allows camera to be only active camera for user to see
#camera needs to be offset to see center of bird and obstacles

#onready var bird declares node when scene tree is ready
#onready must be used as without it node is declared when scene tree is not ready (game not ready)
#get_node("../Bird") gets bird node from the same parent node of camera (GameStage)

#node heirachy - scene tree -> root node -> parent/main node(Node2D) -> child node(camera2D)

#bird node is retrieved from scene tree -> root node -> parent node(get_child(0) gets child node of root node) -> child node
#onready var bird = get_tree().get_root().get_node("GameStage").get_node("Bird")
onready var bird = get_parent().get_node("Bird")

func _ready():
	pass

func _physics_process(delta):
	#set camera position to x position of bird
	position = Vector2(bird.position.x, position.y)

#adjust ground spawner with camera offset
func get_total_position():
	return get_global_position() + offset
