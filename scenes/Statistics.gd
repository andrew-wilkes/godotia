extends MarginContainer

signal game_over

var lives setget _lives
var health setget _health
var level setget _level
var score setget _score
var population setget _population
var time setget _time
var energy setget _energy
var max_energy = 0
var nodes

func _ready():
	nodes = {
		lives = $HBox/Left/Lives,
		health = $HBox/Left/Health,
		level = $HBox/Left/Level,
		score = $HBox/Left/Score,
		population = $HBox/Right/Pop,
		time = $HBox/Right/Time,
		energy = $HBox/Right/Energy
	}


func reset():
	_lives(3)
	_health(100)
	_level(1)
	_score(0)
	_time(0)
	start_clock()
	update()


func update():
	var status = globals.get_status()
	_population(status.p)
	_energy(status.e)


func _lives(n):
	lives = n
	var i = 0
	for node in nodes.lives.get_children():
		node.visible = i < n
		i += 1


func _health(n):
	health = n
	nodes.health.value = n


func _level(n):
	level = n
	nodes.level.text = "Level: %d" % n


func _score(n):
	score = n
	nodes.score.text = "Score: %05d" % n


func _population(n):
	population = n
	nodes.population.text = "Population: %d" % n


func _time(n):
	time = n
	nodes.time.text = "Survival time: %02d:%02d" % [n / 100, n % 100]


func _energy(n):
	if n > max_energy:
		max_energy = n
	energy = n * 100 / max_energy
	nodes.energy.value = energy


func _on_Clock_timeout():
	self.time += 1


func start_clock():
	_time(0)
	$Clock.start()


func stop_clock():
	$Clock.stop()


func add_points(points):
	self.score += points


func reduce_health(sid):
	self.health -= 1
	if health <= 0:
		lose_life(sid)


func lose_life(sid):
	self.lives -= 1
	var respawn = self.lives > 0
	globals.player.explode(respawn)
	if sid and globals.structures.has(sid):
			globals.structures[sid].destroy()
	if !respawn:
		emit_signal("game_over")
