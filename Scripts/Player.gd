extends KinematicBody

export var speed = 10.0
export var h_acceleration = 3.0
export var gravity = 1.0

var full_contact = false
var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vector = Vector3()
var walking = false

export var mouse_sensitivity : float = 0.3
onready var head = $Head
onready var ground_check = $GroundCheck
onready var basementfs = $BasementFS

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion :
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
func _physics_process(delta):
	

		
	direction = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor() :
		gravity_vector += Vector3.DOWN * gravity * delta
	elif is_on_floor() and full_contact:
		gravity_vector = -get_floor_normal() * gravity
	else:
		gravity_vector = -get_floor_normal()
	
	
	if Input.is_action_pressed("move_forward") :
		direction -= transform.basis.z
		
	elif Input.is_action_pressed("move_back") :
		direction += transform.basis.z
		
	if Input.is_action_pressed("strafe_left") :
		direction -= transform.basis.x
		
	elif Input.is_action_pressed("strafe_right") :
		direction += transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vector.z
	movement.x = h_velocity.x + gravity_vector.x
	movement.y = gravity_vector.y
	
	move_and_slide(movement, Vector3.UP)
	
	if movement.x != 0 or movement.y !=0 or movement.z !=0:
		walking = true
	else:
		walking = false
		
	if walking and !basementfs.playing:
		basementfs.play()
	if not walking and !basementfs.playing:
		basementfs.stop()
		
		
