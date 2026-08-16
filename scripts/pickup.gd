extends Interactable
class_name Pickup

@export var item : ItemData
@export var canMove := false

func interact():
	if Inventorymanager.add_item(item):
		queue_free()
