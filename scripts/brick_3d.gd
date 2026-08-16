extends Pickup

func interact():
	Inventorymanager.add_item(item)
	queue_free()
