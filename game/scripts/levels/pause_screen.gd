###
# This script is responsible for pause screen.
# Author: Breno Viana
# Version: 16/11/2017
###
extends Node2D

func _ready():
	""" Called every time the node is added to the scene.
		Initialization here. """
	# Set process
	Globals.set("pause_itens", [])
	Globals.set("pause_current_item", 0)
	Globals.get("pause_itens").append(get_node("panel/bt_continue"))
	Globals.get("pause_itens").append(get_node("panel/bt_quit"))
	
	set_process(true)
	set_process_input(true)

func _process(delta):
	Globals.get("pause_itens")[Globals.get("pause_current_item")].grab_focus()
	
	
	# Continue
	if(get_node("panel/bt_continue").is_pressed()):
		Globals.set("paused", false)

	# Quit game
	if(get_node("panel/bt_quit").is_pressed()):
		get_tree().quit()
		
	# Check if the game is not paused
	if(not Globals.get("paused")):
		queue_free()
		
func _input(event):
	if(event.type == InputEvent.KEY):
		if(event.is_action_pressed("ui_up")):
			if(Globals.get("pause_current_item") == 0):
				Globals.set("pause_current_item",Globals.get("pause_itens").size()-1)
			else:	
				Globals.set("pause_current_item", Globals.get("pause_current_item")-1)
			Globals.get("pause_itens")[Globals.get("pause_current_item")].grab_focus()
		if(event.is_action_pressed("ui_down")):
			if(Globals.get("pause_current_item") == Globals.get("pause_itens").size()-1):
				Globals.set("pause_current_item",0)
			else:	
				Globals.set("pause_current_item", Globals.get("pause_current_item")+1)
			Globals.get("pause_itens")[Globals.get("pause_current_item")].grab_focus()
