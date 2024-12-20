extends Node

signal entries_got
signal entry_sent

@export var api_key: String = ""
@export var base_url: String = "https://api.simpleboards.dev/api/"

@onready var http_request: HTTPRequest = HTTPRequest.new()

func _ready():
	add_child(http_request)
	http_request.connect("request_completed", _on_request_completed)

func set_api_key(key: String):
	"""Sets the API key for authentication."""
	api_key = key

func get_entries(leaderboard_id: String):
	"""Fetches leaderboard entries for a given leaderboard ID."""
	var url = base_url + "leaderboards/%s/entries" % leaderboard_id
	var headers = ["x-api-key: " + api_key]
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	await http_request.request_completed

func send_score_with_id(leaderboard_id: String, 
		player_display_name: String, 
		score: String,
		metadata: String,
		player_id: String):
	"""Submits a player's score to the leaderboard."""
	var url = base_url + "entries"
	var headers = [
		"x-api-key: " + api_key,
		"Content-Type: application/json"
	]
	var body = {
		"leaderboardId": leaderboard_id,
		"playerId": player_id,
		"playerDisplayName": player_display_name,
		"score": score,
		"metadata": metadata
	}
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	await http_request.request_completed
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		
func send_score_without_id(leaderboard_id: String, 
		player_display_name: String, 
		score: String,
		metadata: String):
	"""Submits a player's score to the leaderboard."""
	var url = base_url + "entries"
	var headers = [
		"x-api-key: " + api_key,
		"Content-Type: application/json"
	]
	var body = {
		"leaderboardId": leaderboard_id,
		"playerDisplayName": player_display_name,
		"score": score,
		"metadata": metadata
	}
	
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(body))
	await http_request.request_completed
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = JSON.parse_string(body.get_string_from_utf8())
		if response is Array:
			entries_got.emit(response)
		else:
			entry_sent.emit(response)
	else:
		print("HTTP Request failed: ", response_code, body)
