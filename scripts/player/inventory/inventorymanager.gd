extends Node

var hotbar: Array[ItemData] = [
	null,
	null,
	null,
	null
]
var selected_slot := -1

func add_item(item : ItemData):
	for i in hotbar.size():
		if hotbar[i] == null:
			hotbar[i] = item
			return true
	return false

signal select(index: int)
func selectItem(index):
	if selected_slot == index:
		selected_slot = -1
	else:
		selected_slot = index
	select.emit(selected_slot)

func remove_selected_item():
	if selected_slot == -1:
		return
	hotbar[selected_slot] = null

func get_selected_item() -> ItemData:
	if selected_slot == -1:
		return null
	return hotbar[selected_slot]
