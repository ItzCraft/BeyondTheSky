class_name BrickItem extends ItemData

func _init():
	id = "brick"
	display_name = "Brick"
	consume_on_use = true

func use_item(target):
	print("hi")
