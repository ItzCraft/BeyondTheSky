extends CanvasLayer

@onready var container = $HBoxContainer
var currentSlot = null


func _ready() -> void:
	Inventorymanager.select.connect(_selectItem)

func _process(delta: float) -> void:
	for i in range(len(Inventorymanager.hotbar)):
		var item = Inventorymanager.hotbar[i]
		var container_width = container.size.x
		var label = container.get_child(i).get_node("Label")
		
		for g in range(container.get_child_count()):
			var panel = container.get_child(g)
			var colorRect = panel.get_node("ColorRect")
			panel.size.x = container_width/container.get_child_count()
			colorRect.size.x = panel.size.x
			colorRect.size.y = panel.size.y
			
		if item != null:
			label.text = item.display_name
		else:
			label.text = ""
			
func _selectItem(index: int):
	if currentSlot!=null:
		var label = container.get_child(currentSlot).get_node("ColorRect")
		if currentSlot == index:
			label.visible = false
			currentSlot = null
			return
		label.visible = false
	var label = container.get_child(index).get_node("ColorRect")
	label.visible = true
	currentSlot = index
