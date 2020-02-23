extends MarginContainer

var lives
var health
var level
var score
var population
var time
var energy

func _ready():
	lives = $HBox/Left/Lives
	health = $HBox/Left/Health
	level = $HBox/Left/Level
	score = $HBox/Left/Score
	population = $HBox/Right/Pop
	time = $HBox/Right/Time
	energy = $HBox/Right/Energy
