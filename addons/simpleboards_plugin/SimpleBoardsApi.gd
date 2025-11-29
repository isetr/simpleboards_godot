extends Node

signal entries_got(entries)
signal entry_sent(entry)
signal request_failed(response_code, body)

@export var api_key: String = ""
@export var base_url: String = "https://api.simpleboards.dev/api/"

func set_api_key(key: String):
	"""Sets the API key for authentication."""
	api_key = key


func get_entries(leaderboard_id: String):
	"""Fetches leaderboard entries for a given leaderboard ID."""
	var url = base_url + "leaderboards/%s/entries" % leaderboard_id
	var headers = [
		"x-api-key: " + api_key
	]

	var response = await _perform_request(HTTPClient.METHOD_GET, url, headers)
	if response == null:
		return

	var response_code = response.response_code
	var body = response.body

	if response_code == 200:
		var parsed = JSON.parse_string(body.get_string_from_utf8())
		if parsed is Array:
			entries_got.emit(parsed)
		else:
			entry_sent.emit(parsed)
	else:
		request_failed.emit(response_code, JSON.parse_string(body.get_string_from_utf8()))


func send_score_with_id(
		leaderboard_id: String,
		player_display_name: String,
		score,
		metadata,
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

	var response = await _perform_request(
		HTTPClient.METHOD_POST,
		url,
		headers,
		JSON.stringify(body)
	)
	if response == null:
		return

	var response_code = response.response_code
	var response_body = response.body

	if response_code == 200:
		var parsed = JSON.parse_string(response_body.get_string_from_utf8())
		entry_sent.emit(parsed)
	else:
		request_failed.emit(response_code, JSON.parse_string(response_body.get_string_from_utf8()))


func send_score_without_id(
		leaderboard_id: String,
		player_display_name: String,
		score,
		metadata):
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

	var response = await _perform_request(
		HTTPClient.METHOD_POST,
		url,
		headers,
		JSON.stringify(body)
	)
	if response == null:
		return

	var response_code = response.response_code
	var response_body = response.body

	if response_code == 200:
		var parsed = JSON.parse_string(response_body.get_string_from_utf8())
		entry_sent.emit(parsed)
	else:
		request_failed.emit(response_code, JSON.parse_string(response_body.get_string_from_utf8()))


func _perform_request(method: int, url: String, headers: Array, body := ""):
	var http_request := HTTPRequest.new()
	add_child(http_request)

	var err = http_request.request(url, headers, method, body)
	if err != OK:
		http_request.queue_free()
		push_error("HTTP request creation failed with error code %s" % err)
		return null

	var result = await http_request.request_completed
	http_request.queue_free()

	var response = {
		"result": result[0],
		"response_code": result[1],
		"headers": result[2],
		"body": result[3]
	}
	return response
