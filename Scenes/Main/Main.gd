extends Node2D

export (PackedScene) var Mob
var score


func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _start_game():
	$MobTimer.start()
	$ScoreTimer.start()


func _update_score():
	score += 1
	$HUD.update_score(score)


func _spawn_mob():
	# set a random position along the path
	$MobPath/MobSpawnLocation.offset = randi()
	
	var mob = Mob.instance()
	
	# add the mob instance into the scene
	add_child(mob)
	mob.spawn($MobPath/MobSpawnLocation.position, $Player.position)
	
	# remove any remaining mobs at the start of a new game
	# warning-ignore:return_value_discarded
	$HUD.connect("start_game", mob, "_on_start_game")
