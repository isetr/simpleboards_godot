# SimpleBoards Godot Plugin

Manage [SimpleBoards](https://simpleboards.dev) leaderboards directly from the Godot Editor. This plugin allows you to interact with the SimpleBoards API to fetch leaderboard entries and submit scores.

## Features

- Free leaderboard service (see [Pricing](https://simpleboards.dev) for paid plans).
- Fetch leaderboard entries.
- Submit scores with or without a player ID.
- Easy integration with the Godot Editor.
- Fully customizable and extendable using GDScript.

## Requirements

- Godot Engine 4.x
- A SimpleBoards API key. You can generate one by registering at [SimpleBoards](https://simpleboards.dev).

## Installation

1. Download or clone this repository into your Godot project under the `addons/` folder:
   ```sh
   git clone https://github.com/isetr/simpleboards_godot.git addons/simpleboards_plugin
   ```

2. Enable the plugin in the Godot Editor:
   - Go to `Project Settings` > `Plugins`.
   - Find `SimpleBoards` in the list and enable it.

3. The plugin will now be available in your project.

## Usage

### Setup

1. Create an instance of the `SimpleBoardsApi` node in your scene.
2. Set your API key in the `SimpleBoardsApi` node's properties or via script.

### Example Scene

```gdscript
extends Node2D

@onready var simpleboards = $SimpleBoardsApi

func _ready():
    # Set the API key
    simpleboards.set_api_key("your_api_key")
    
    # Connect signals
    simpleboards.entries_got.connect(_on_entries_got)
    simpleboards.entry_sent.connect(_on_entry_sent)
    
    # Send a score
    await simpleboards.send_score_without_id("leaderboard_id", "PlayerName", "12345", "{}")
    await simpleboards.send_score_with_id("leaderboard_id", "PlayerName", "12345", "{}", "1")
    
    # Get leaderboard entries
    await simpleboards.get_entries("leaderboard_id")

func _on_entries_got(entries):
    for entry in entries:
        print(entry)

func _on_entry_sent(entry):
    print(entry)
```

### Signals

- `entries_got`: Emitted when leaderboard entries are successfully fetched.
  - **Arguments**: `Array` of entries.
- `entry_sent`: Emitted when a score is successfully submitted.
  - **Arguments**: `Dictionary` containing the server response.

### API Methods

#### `set_api_key(key: String)`
Sets the API key for authentication.

#### `get_entries(leaderboard_id: String)`
Fetches leaderboard entries for a given leaderboard ID.
- **Arguments**:
  - `leaderboard_id`: The ID of the leaderboard.

#### `send_score_with_id(leaderboard_id: String, player_display_name: String, score: String, metadata: String, player_id: String)`
Submits a player's score to the leaderboard, including a player ID.
- **Arguments**:
  - `leaderboard_id`: The ID of the leaderboard.
  - `player_display_name`: The display name of the player.
  - `score`: The player's score.
  - `metadata`: Additional metadata (JSON string).
  - `player_id`: The player's unique ID.

#### `send_score_without_id(leaderboard_id: String, player_display_name: String, score: String, metadata: String)`
Submits a player's score to the leaderboard without a player ID.
- **Arguments**:
  - `leaderboard_id`: The ID of the leaderboard.
  - `player_display_name`: The display name of the player.
  - `score`: The player's score.
  - `metadata`: Additional metadata (JSON string).

### Response Object

When a score is successfully submitted, the emitted `entry_sent` signal will provide a response object with the following structure:

```json
{
  "id": "string",
  "leaderboardId": "string",
  "playerId": "string",
  "playerDisplayName": "string",
  "score": "string",
  "metadata": "string"
}
```

## License

This plugin is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit issues and pull requests to improve this plugin. Contributions are always welcome!

## Support

For questions or support, please visit [SimpleBoards](https://simpleboards.dev) or contact us directly.

---

Happy coding!
