#global script
extends Node

var score_best = 0 setget _set_score_best
var score_current = 0 setget _set_score_current

#store best score data
const FILEPATH = "user://bestscore.data"

#declare scores for medals
const BRONZE_MEDAL = 10
const SILVER_MEDAL = 20
const GOLD_MEDAL = 30
const PLATINUM_MEDAL = 40

#used to know when current score changes and update HUD
signal score_current_changed
#used to know when best score changes and update HUD
signal score_best_changed
#used to know medal change
signal medal_changed


func _ready():
	#open file for best score
	load_bestscore()
	#connect stage changed signal
	StageManager.connect("stage_changed", self, "_on_stage_changed")

#when game restarts the score resets
func _on_stage_changed():
	score_current = 0

func _get_medal(value):
	if value >= BRONZE_MEDAL:
		emit_signal("medal_changed")
	elif value >= SILVER_MEDAL:
		emit_signal("medal_changed")
	elif value >= GOLD_MEDAL:
		emit_signal("medal_changed")
	elif value >= PLATINUM_MEDAL:
		emit_signal("medal_changed")

func _set_score_best(value):
	#if score is better then best score emit signal
	if value > score_best:
		#set best score to the changing value that occurs
		score_best = value
		#signal score changed emitted every time best score changes
		emit_signal("score_best_changed")
	#save best score
	save_bestscore()

# set function calls function every time variable is changed
func _set_score_current(value):
	#set current score to the changing value that occurs
	score_current = value
	#signal score changed emitted every time current score changes
	emit_signal("score_current_changed")

#load bestscore
func load_bestscore():
	#create new file handling 
	var file = File.new()
	#if file don't exist (when game is first run best score file don't exist) return file
	if not file.file_exists(FILEPATH):
		return
	#open file from FILEPATH and READ file (READ is passed as flag)
	file.open(FILEPATH, file.READ)
	#get temporary stored best score value from file
	score_best = file.get_var()
	#closes file
	file.close()

#save bestscore
func save_bestscore():
	#create new file handling
	var file = File.new()
	#open file from FILEPATH and write data into file
	file.open(FILEPATH, file.WRITE)
	#store temporary the bestscore to the file
	file.store_var(score_best)
	#close file
	file.close()

