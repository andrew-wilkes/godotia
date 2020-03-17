extends Node

class_name StateMachine

const DEBUG = false

var state: Object

func _ready():
	# Set the initial state to the first child node
	state = get_child(0)
	call_deferred("_enter_state")
	
func change_to(new_state):
	state = get_node(new_state)
	_enter_state()


func _enter_state():
	if DEBUG:
		print("Entering state: ", state.name)
	# Give the new state a reference to it's state machine i.e. this one
	state.fsm = self
	state.enter()

# Route Game Loop function calls to
# current state handler method if it exists
func _process(delta):
	if state.has_method("process"):
		state.process(delta)
