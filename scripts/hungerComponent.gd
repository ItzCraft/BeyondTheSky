class_name HungerComponent extends Node

signal hunger_changed(current, max_hunger)
signal out_of_hunger

@export var max_hunger: float = 10
var hunger := max_hunger
var hunger_loss: float = 0.5
@onready var timer: Timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	hunger = max_hunger
	
func hunger_change(amount:float):
	hunger = max(max_hunger, hunger+amount)

func _on_timer_timeout():
	hunger = max(0, hunger - hunger_loss)
	hunger_changed.emit(hunger, max_hunger)
