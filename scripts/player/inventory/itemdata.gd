extends Resource
class_name ItemData

@export var id : String
@export var display_name : String
@export var icon : Texture2D
@export var world_scene : PackedScene
@export var consume_on_use := false

func use_item(target):
	pass
