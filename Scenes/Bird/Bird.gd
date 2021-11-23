extends RigidBody2D

#set current state which will run _init() in any of the State and passes self node
onready var state = FlyingState.new(self)

#set speed of bird moving rightwards
export var speed = 300

#signals change of state
signal state_changed

#get previous state
var prev_state 

#used to identify the different states
const STATE_FLYING = 0
const STATE_FLAPPING = 1
const STATE_HIT = 2
const STATE_GROUNDED = 3

var birdAnim = ["BlueFlap", "RedFlap", "Flap"]

#initialise when node is added to scene
#_ready() is callback or return function
func _ready():
	#add bird to group "Bird"
	add_to_group("Bird")
	#connect signal when bird hits collision (contact monitor is true so signal is emitted when body is collided)
	connect("body_entered", self, "_on_Body_entered")
	$AnimatedSprite.animation = birdAnim[rand_range(0,3)]

#function called every frame
func _physics_process(delta):
	#states update(delta) function will be called in place with _physics_process()
	state.update(delta)
	var x = 0 
	x+=1
	print(x)

#function every time any input is used (mouse movement)
func _input(event):
	#states input(event) function will be called in place with input()
	state.input(event)
	if state.has_method("input"):
		state.input(event)

func _on_Body_entered(body):
	#if any state has method on_Bird_Body_entered the function will be called
	if state.has_method("on_Bird_Body_entered"):
		#delegate function to current state
		state.on_Bird_Body_entered(body)

#used as identifer for one of the states
func set_state(new_state):
	#state has finished
	state.exit()
	#set previous state
	prev_state = get_state()
	
	#if new state is either one of the given states assign state to given state
	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundState.new(self)
	
	#other nodes connect to bird node need to know states
	emit_signal("state_changed", self)

#get current state
func get_state():
	#if the state is an instance of a state (return which state is in use)
	if state is FlyingState:
		return STATE_FLYING
	elif state is FlappingState:
		return STATE_FLAPPING
	elif state is HitState:
		return STATE_HIT
	if state is GroundState:
		return STATE_GROUNDED
	

#4 Classes that represent the 4 states for the bird fly, flap, hit, ground (finite state machine) 

#Class flying state -----------------------------------------------------------------------------------------

#create flying state class 
class FlyingState:
	#get bird reference to use functions from bird node (StaticBody2D)
	var bird
	#get previous gravity scale so bird can fall
	var prev_gravity_scale
	
	#describe what the bird should do when in flying state
	
	#called when object of this class has been created (constructor of class)
	#perform actions with nodes
	func _init(bird):
		#declare bird reference
		self.bird = bird 
		#play fly animation
		bird.get_node("AnimationPlayer").play("Fly")
		#bird is moving rightwards constantly at 150 pixels when flying
		bird.linear_velocity = Vector2(bird.speed, bird.linear_velocity.y)
		#save gravity value 
		prev_gravity_scale = bird.gravity_scale
		#set gravity to 0 so bird is flying
		bird.gravity_scale = 0
	
	#update frame by frame actions using delta time
	func update(delta):
		pass
	
	#handle user input
	func input(event):
		pass
	
	#know when its end of state and perform actions before going to another state
	func exit():
		#when state is exited gravity scale reverts back to original gravity scale
		bird.gravity_scale = prev_gravity_scale
		#stop flying animation when state is exited
		bird.get_node("AnimationPlayer").stop()

#Class flapping state ---------------------------------------------------------------------------------------

#create flapping state
class FlappingState:
	#get bird reference to use functions from bird node (StaticBody2D)
	var bird
	#describe what the bird should do when in flapping state
	
	#called when object of this class has been created
	func _init(bird):
		#declare bird reference
		self.bird = bird
		#bird is moving rightwards constantly at 150 pixels
		bird.linear_velocity = Vector2(bird.speed, bird.linear_velocity.y)
		#when screen starts bird flaps
		flap()
	
	#update frame by frame actions using delta time
	func update(delta):
		#if bird rotation is less than -30 degrees (30 degress anticlockwise) rate of velocity of the bird rotaing is 0
		if rad2deg(bird.rotation) <  -30:
			#bird points upwards when flapping
			bird.angular_velocity = 0
	
		#if bird is falling and not flapping then bird is pointing downwards
		if bird.linear_velocity.y > 0:
			#bird rotates 1.5 pixels per frame clockwise
			bird.angular_velocity = 1.5
	
	#handle user input
	func input(event):
		#if user touch screen bird flaps
		if event is InputEventScreenTouch:
			#if user event press screen screen bird flap
			if event.pressed:
			#bird flaps when user press space
				flap()
	
	#calls _on_body_entered signal and sets state for signal from this function
	func on_Bird_Body_entered(body):
		#if bird collided with body in group pipes bird state is STATE_HIT 
		if body.is_in_group("Pipes"):
			bird.set_state(bird.STATE_HIT)
		#if bird collided with body in group ground bird state is STATE_GROUNDED
		elif body.is_in_group("Ground"):
			bird.set_state(bird.STATE_GROUNDED)
	
	func flap():
		#y velocity of bird changes while x velocity remains constant
		bird.linear_velocity = Vector2(bird.linear_velocity.x, -250)
		#bird points upwards when flapping (rotational velocity spins anti clockwise)
		bird.angular_velocity = -3
		#animation plays every time bird flaps
		bird.get_node("AnimationPlayer").play("Flap")
		#play flap sound
		Audio.get_node("BirdFlap").play()
	
	#know when its end of state and perform actions before going to another state
	func exit():
		bird.get_node("AnimationPlayer").stop()

#Class hit state ---------------------------------------------------------------------------------------

#create hit state
class HitState:
	#get bird reference to use functions from bird node (StaticBody2D)
	var bird
	#describe what the bird should do when in hit state
	
	#called when object of this class has been created
	func _init(bird):
		#declare bird reference
		self.bird = bird
		#when bird is hit velocity is 0
		bird.linear_velocity = Vector2(0,0)
		#bird face downwards when falling
		bird.angular_velocity = 2
		
		#--make sure bird can not collide with pipe once it hits pipe so bird falls straight to ground--
		#returns array of colliding bodies of which the bird collides with
		#get the first collision from colliding bodies (the pipe)
		var body = bird.get_colliding_bodies()[0]
		#Adds a body to the list of bodies that bird can't collide with as bird can collide with pipe only once
		bird.add_collision_exception_with(body)
		#play hit sound
		Audio.get_node("BirdHit").play()
		#play die sound when bird is fallng
		Audio.get_node("BirdDie").play()
		
	#update frame by frame actions using delta time
	func update(delta):
		pass
	
	#handle user input
	func input(event):
		pass
	
	#if bird body collide with ground change state to STATE_GROUNDED
	func on_Bird_Body_entered(body):
		if body.is_in_group("Ground"):
			bird.set_state(bird.STATE_GROUNDED)
	
	#know when its end of state and perform actions before going to another state
	func exit():
		pass

#Class ground state ---------------------------------------------------------------------------------------

#create ground state
class GroundState:
	#get bird reference to use functions from bird node (StaticBody2D)
	var bird
	#describe what the bird should do when in ground state
	
	#called when object of this class has been created
	func _init(bird):
		#declare bird reference
		self.bird = bird
		#bird don't move when it hits ground linear velocity is 0 and angular velocity is 0
		bird.linear_velocity = Vector2(0,0)
		bird.angular_velocity = 0
		#if bird previous state is not state_hit play sound
		if bird.prev_state != bird.STATE_HIT:
			Audio.get_node("BirdHit").play()
	
	#update frame by frame actions using delta time
	func update(delta):
		pass
	
	#handle user input
	func input(event):
		pass
	
	#know when its end of state and perform actions before going to another state
	func exit():
		pass
