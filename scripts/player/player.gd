extends CharacterBody3D

@export var speed: float = 5
var actual_speed: float = 0.01
var acceleration: float = 5
# rework it to use coefficient of floor to calculate deceleration
@export var deceleration: float = 35
@export var jump_velocity: float = 4.5

@export var mouse_sensitivity: float = 0.002

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interaction_raycast: RayCast3D = $Head/Camera3D/RayCast3D
@onready var flashlight: SpotLight3D = $Head/Camera3D/SpotLight3D
@onready var health: HealthComponent = $HealthComponent
@onready var hunger: HungerComponent = $HungerComponent

@export var carry_distance: float = 3.0
@export var carry_speed: float = 20.0

var held_prop: StaticBody3D = null
var flash_visible: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health.died.connect(_on_death)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var target_velocity_x = direction.x * speed
	var target_velocity_z = direction.z * speed
	
	if direction != Vector3.ZERO:
		velocity.x = lerp(velocity.x, target_velocity_x, 15.0 * delta)
		velocity.z = lerp(velocity.z, target_velocity_z, 15.0 * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, 25.0 * delta)
		velocity.z = lerp(velocity.z, 0.0, 25.0 * delta)

	move_and_slide()

func _process(delta: float):
	if held_prop != null:
		if Input.is_action_just_released("lmb"):
			drop_prop()
			return
			
		var target_position = calculate_hold_position()
		move_prop_smoothly(held_prop, target_position, delta)
		
	elif interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()
		print(Inventorymanager.hotbar)
		print(Inventorymanager.selected_slot)
		if collider is Interactable and Input.is_action_just_pressed("interact"):
			collider.interact()
				
		if Input.is_action_just_pressed("lmb") and collider is Interactable and collider.canMove == true:
			pick_up_prop(collider)
			
	var item = Inventorymanager.get_selected_item()
	if item != null:
		if Input.is_action_just_pressed("interact"):
			item.use_item(item)
			if item.consume_on_use:
				Inventorymanager.remove_selected_item()
			
	if Input.is_action_just_pressed("1"):
		Inventorymanager.selectItem(0)
	if Input.is_action_just_pressed("2"):
		Inventorymanager.selectItem(1)
	if Input.is_action_just_pressed("3"):
		Inventorymanager.selectItem(2)
	if Input.is_action_just_pressed("4"):
		Inventorymanager.selectItem(3)
	if Input.is_action_just_pressed("F"):
		if flash_visible:
			flash_visible = false
			flashlight.visible = false
			return
		flashlight.visible = true
		flash_visible = true

func calculate_hold_position() -> Vector3:
	var camera_forward = -camera.global_transform.basis.z
	return camera.global_transform.origin + (camera_forward * carry_distance)

func pick_up_prop(prop: StaticBody3D):
	held_prop = prop
	
	if held_prop.has_node("CollisionShape3D"):
		held_prop.get_node("CollisionShape3D").disabled = true

func drop_prop():
	if held_prop != null and held_prop.has_node("CollisionShape3D"):
		held_prop.get_node("CollisionShape3D").disabled = false
	held_prop = null

func move_prop_smoothly(prop: StaticBody3D, target_pos: Vector3, delta: float):
	prop.global_transform.origin = prop.global_transform.origin.lerp(target_pos, carry_speed * delta)

func _on_death():
	queue_free()
