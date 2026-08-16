class_name HealthComponent extends Node

signal health_changed(current, max_health)
signal died

@export var max_health: float = 100

var health := max_health

func _ready():
	health = max_health
	
func damage(amount: float):
	health = max(0, health-amount)
	health_changed.emit(health, max_health)
	
	if health <= 0:
		died.emit()

func heal(amount: float):
	health = max(max_health, health+amount)
	health_changed.emit(health, max_health)
