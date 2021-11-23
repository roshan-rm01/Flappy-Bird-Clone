extends CanvasLayer

const NIGHT = preload("res://flappy bird - sprites/background_night.png")
const DAY = preload("res://flappy bird - sprites/background_day.png")

var background = [NIGHT, DAY] 

func _ready():
	randomize()
	$Sprite.texture = background[rand_range(0,2)]
