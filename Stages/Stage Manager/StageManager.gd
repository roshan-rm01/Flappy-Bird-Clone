extends CanvasLayer

#GameStage scene
const GAMESTAGE = "res://Stages/GameStage.tscn"
#Menu scene
const MENU = "res://Stages/Menu/Menu.tscn"

const HIGHSCORE = "res://Stages/HighScore/BestScore.tscn"
#stage changing is either true or false
var is_changing = false

#stage changes
signal stage_changed

func _ready():
	pass

func change_stage(stage_path):
	#allow function to change the scene once
	if is_changing:
		return
	
	#stage changing is true
	is_changing = true
	
	#stage manager should fade to black play sound
	get_node("AnimationPlayer").play("FadeIn")
	Audio.get_node("Swoosh").play()
	#yield makes function change_state(stage_path) wait until signal is emiited
	yield(get_node("AnimationPlayer"),"animation_finished")
	#stage manager should change stage scene
	get_tree().change_scene(stage_path)
	emit_signal("stage_changed")
	#stage manager should fade from black
	get_node("AnimationPlayer").play("FadeOut")
	#wait for scene to change to prevent user from pressing and restarting the game more then once in a single game
	yield(get_node("AnimationPlayer"), "animation_finished")
	
	#stage finishes changing
	is_changing = false
