extends Node

func sound_stop():
	var birdDie = Audio.get_node("BirdDie")
	var birdFlap = Audio.get_node("BirdFlap")
	var birdHit = Audio.get_node("BirdHit")
	var coin = Audio.get_node("CoinPoint")
	
	birdDie.stop()
	birdFlap.stop()
	birdHit.stop()
	coin.stop()
