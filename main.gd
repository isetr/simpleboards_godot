extends Node2D

@onready var simpleboards = $SimpleBoardsApi

func _ready():
	# Set the API key
	simpleboards.set_api_key("api_key")
	simpleboards.entries_got.connect(_on_entries_got)
	simpleboards.entry_sent.connect(_on_entry_sent)
	simpleboards.request_failed.connect(_on_request_failed)
	
	# Send a score
	await simpleboards.send_score_without_id("leaderboard_id", "PlayerName", "12345", "[]")
	await simpleboards.send_score_with_id("leaderboard_id", "PlayerName", "12345", "[]", "1")
	
	# Get leaderboard entries
	await simpleboards.get_entries("leaderboard_id")

func _on_entries_got(entries):
	for entry in entries:
		print(entry)
	
func _on_entry_sent(entry):
	print(entry)
	
func _on_request_failed(response_code, body):
	print(response_code, body)
