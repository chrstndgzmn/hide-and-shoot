extends CharacterBody3D
@onready var head:= $head
@onready var camera:= $head/Camera3D
@onready var hand := $hand
@onready var flashlight := $hand/SpotLight3D 

var speed
const SPRINT_SPEED = 5.0
const WALK_SPEED = 3.0
const JUMP_VELOCITY = 5.0
const SENSITIVITY = 0.01 

const BASE_FOV = 75.0
const FOV_CHANGE = 1.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 9.81

#head bob
const BOB_FREQUENCY = 3;
const BOB_AMP = 0.05;
var t_bob = 0.0

var head_y_axis = 0.0;
var camera_x_axis = 0.0;
var flashlight_sens = 2;
var cameraAcceleration = 0.5;

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
	
func _unhandled_input(event):
	if event is InputEventMouseButton: 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			#head.rotate_y(-event.relative.x * SENSITIVITY)
			#camera.rotate_x(-event.relative.y * SENSITIVITY)
			#camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad((90)))
			head_y_axis += event.relative.x * cameraAcceleration
			camera_x_axis += event.relative.y * cameraAcceleration

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if(Input.is_action_pressed("sprint")):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 5)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 5)
	
	#head bob 
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	#fov
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped;
	camera.fov = lerp(camera.fov,target_fov, delta * 8.0)
	
	#flashlight   
	hand.rotation.y = lerp(hand.rotation.y, -deg_to_rad(head_y_axis), flashlight_sens * delta) 
	var flashlight_rotate = lerp(flashlight.rotation.x, -deg_to_rad(camera_x_axis), flashlight_sens * delta) 
	flashlight.rotation.x = clamp(flashlight_rotate, deg_to_rad(-90), deg_to_rad((90)))  
	
	#camera
	head.rotation.y = -deg_to_rad(head_y_axis) 
	camera.rotation.x = clamp(-deg_to_rad(camera_x_axis), deg_to_rad(-90), deg_to_rad((90))) 
	
	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO;
	pos.y = sin(time*BOB_FREQUENCY) * BOB_AMP
	pos.x = cos(time*BOB_FREQUENCY /2) * BOB_AMP
	return pos
