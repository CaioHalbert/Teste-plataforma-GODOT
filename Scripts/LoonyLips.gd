extends Control

var playerWords = []
var current_story = {}

onready var DisplayText = $VBoxContainer/DisplayText
onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
onready var ButtonText = $VBoxContainer/HBoxContainer/ButtonText

func _ready():
	set_current_story()
	DisplayText.text = "Welcome to Loony Lips! "
	check_player_words_length()
	PlayerText.grab_focus()

func set_current_story():
	var stories = get_from_json("StoryBook.json")
	randomize()
	print(stories)
	current_story = stories[randi() % stories.size()]

func get_from_json(fileName ):
	var file = File.new()
	file.open(fileName, File.READ)
	
	var text = file.get_as_text()
	var data = parse_json(text)
	
	file.close()
	
	return data

func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		add_to_player_words()
	
func _on_PlayerText_text_entered(string):
	add_to_player_words()

func add_to_player_words():
	playerWords.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()

func is_story_done():
	return playerWords.size() == current_story.prompts.size()

func check_player_words_length():
	if is_story_done():
		tell_story()
	else:
		prompt_player()

func tell_story():
	DisplayText.text = current_story.story % playerWords
	end_game()

func prompt_player():
	DisplayText.text += "May I have " + current_story.prompts[playerWords.size()] + " please?"

func end_game():
	ButtonText.text = "Again?"
	PlayerText.queue_free()
