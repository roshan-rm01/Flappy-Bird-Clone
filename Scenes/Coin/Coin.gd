extends Area2D

func _ready():
	#connect body entered signal so bird can receive point when going through pipe
	connect("body_entered", self, "_on_Body_entered") 
	pass

func _on_Body_entered(body):
	#if body collided with is in group bird (if body is bird)
	if body.is_in_group("Bird"):
		#increase game score by 1
		Game.score_current += 1
		#play point sound
		Audio.get_node("CoinPoint").play()
