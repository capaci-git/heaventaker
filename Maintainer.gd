extends Node

func credits() -> void:
	var credit: Node = load("res://Game_resources/Creditos.tscn").instance()
	add_child(credit)

###############################################################################
############################# EVENT_CONTROLLER ################################
onready var dialog_node: = get_node("/root/DialogNode") #"res://addons/dialogs/Dialog.tscn"

#Store the current dialog owner to support run_crossroads
var cur_dialog_owner: = "story"

func new_dialog_event(dialog_owner: String, json_name: String) -> void:
	#Dialog_owner hold the name of directory that contains the desired json file
	#Json_name don't need explanations, right?
	
	#Creating directory path
	var path = "res://Game_resources/Json/"
	json_name += '.json'
	
	print("Owner: %s\nJson: %s" % [dialog_owner,json_name])
	
	var dialog_resource = DialogResource.new()
	
	var dir = Directory.new()
	
	#Seeking for json file inside directories
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				#If found, return it
				if file_name == json_name:
					cur_dialog_owner = dialog_owner
					print("Found file: " + file_name)
					dialog_resource.dialog_json = path + file_name
					dialog_node.load_new_dialog(dialog_resource)
					return
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	#Failing load path
	print("An error occurred when trying to find %s." % [path+json_name])
	dialog_resource.dialog_json = "res://Game_resources/fail.json"
	dialog_node.load_new_dialog(dialog_resource)
	return

###############################################################################
################################### RUN #######################################
var lose_state = 0

func new_run_event(run_scene_path) -> void:
	dialog_node.add_child(load(run_scene_path).instance())
	pass

func run_crossroads(result) -> void:
	if result == 0:
		print("Vem final")
		new_dialog_event(cur_dialog_owner, 'final')
		lose_state = 0
		return
	
	lose_state += result
	
	if lose_state > 2:
		print("Se fudeu")
		new_dialog_event(cur_dialog_owner, 'game_over')
		lose_state = 0
		return
	
	print("Já perdeu %d vez(es)." % lose_state)
	new_dialog_event(cur_dialog_owner, 'lose%d' % lose_state)
	return


###############################################################################
################################# SAVE STUFFS #################################
###############################################################################
############################# NECESSITA ATUALIZAÇÃO ###########################
export(Script) var game_save_class
var save_vars = ["game_events"]

func authentic_save(game_save) -> bool:
	for vars in save_vars:
		if game_save.get(vars) == null:
			return false
	
	return true

func save_game_state() -> void:
	var new_save = game_save_class.new()
	
	#Desenvolva as formas de armazenar as variáveis antes de salvar o arquivo
	#new_save.game_events = game_events
	
	var dir = Directory.new()
	if not dir.dir_exists("res://SaveManager/Save/"):
		dir.make_dir_recursive("res://SaveManager/Save/")
	
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://SaveManager/Save/save_0.tres", new_save)

func load_save() -> bool:
	var dir = Directory.new()
	if not dir.file_exists("res://SaveManager/Save/save_0.tres"):
		return false
	
	var game_save = load("res://SaveManager/Save/save_0.tres")
	
	if not authentic_save(game_save):
		return false
	
	#Carregamento das variaveis envolvidas no save
	#game_events = game_save.game_events
	
	return true


