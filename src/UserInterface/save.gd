extends Node

const SAVEFILE = "user://SAVE_FILE.save"
const SAVEKEYS = "user://key_binds.ini"
const SAVESCORE = "user://SAVE_SCORE.save"
const SAVEACHIEV = "user://SAVE_ACHIEV.save"

var standard_keybinds = {
	"Up": 87,
	"Left": 65,
	"Down": 83,
	"Right": 68,
	"Pause": 80,
	"Attack": 32
}

var game_data = {}
var keybinds = {}
var score = {}
var achievements = {}
var configfile

func _ready():
	load_data()
	load_keys()
	load_score()
	load_achievements()

func load_data():
	var file = File.new()
	if not file.file_exists(SAVEFILE):
		game_data = {
			"fullscreen_on": false,
			"bloom_on": true,
			"vsync_on": true,
			"brightness": 1,
			"master_vol": -10,
			"music_vol": -20,
			"sfx_vol": -20,
			"language": "en"
		}
		save_data()
	file.open(SAVEFILE, File.READ)
	game_data = file.get_var()
	file.close()

func load_keys():
	configfile = ConfigFile.new()
	if configfile.load(SAVEKEYS) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
	else:
		# Create .ini file
		for key in standard_keybinds.keys():
			var key_value = standard_keybinds[key]
			configfile.set_value("keybinds", key, key_value)
		configfile.save(SAVEKEYS)
		keybinds = standard_keybinds.duplicate()

func load_score():
	var file = File.new()
	if not file.file_exists(SAVESCORE):
		score = {
			"best_time": -1.0,
			"l01_torch": 0.0,
			"l01_time": 0.0,
			"l01_kills": 0,
			"l01_deaths": 0,
			"l02_torch": 0.0,
			"l02_time": 0.0,
			"l02_kills": 0,
			"l02_deaths": 0,
			"l03_torch": 0.0,
			"l03_time": 0.0,
			"l03_kills": 0,
			"l03_deaths": 0,
			"l04_torch": 0.0,
			"l04_time": 0.0,
			"l04_kills": 0,
			"l04_deaths": 0,
			"l05_torch": 0.0,
			"l05_time": 0.0,
			"l05_kills": 0,
			"l05_deaths": 0
		}
		save_score()
	file.open(SAVESCORE, File.READ)
	score = file.get_var()
	file.close()

func load_achievements():
	var file = File.new()
	if not file.file_exists(SAVEACHIEV):
		achievements = {
			"One With the Darkness": false,
			"One With the Light": false,
			"Merciless Wretch!": false,
			"Speedrunner": false,
			"You Can DO IT!": false,
			"Leave no Stone Unturned": false
		}
		save_achievements()
	file.open(SAVEACHIEV, File.READ)
	achievements = file.get_var()
	file.close()

func save_data():
	var file = File.new()
	file.open(SAVEFILE, File.WRITE)
	file.store_var(game_data)
	file.close()

func save_keys():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
		else:
			configfile.set_value("keybinds", key, "")
	configfile.save(SAVEKEYS)

func save_score():
	var file = File.new()
	file.open(SAVESCORE, File.WRITE)
	file.store_var(score)
	file.close()

func save_achievements():
	var file = File.new()
	file.open(SAVEACHIEV, File.WRITE)
	file.store_var(achievements)
	file.close()
