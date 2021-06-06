extends KinematicBody3D

@export var GRAVITY:float = -24.8
@export var MAX_SPEED:float = 20
@export var ACCEL:float = 4.5
@export var DEACCEL:float = 16
@export var MAX_SLOPE_ANGLE:float = 40

@onready var gizmo:Node3D = $Gizmo

@onready var cam:Camera3D = $Gizmo/Camera3D

var dir:Vector3
var vel:Vector3


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta:float):
	dir = Vector3()
	
	var cam_xform = cam.get_global_transform()
	var input:Vector2
	input.y = int(Input.is_action_pressed("ui_up")) - int(Input.is_action_pressed("ui_down"))
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_right"))
	
	input = input.normalized()
	dir += -cam_xform.basis.z * input.y
	dir += cam_xform.basis.x * input.x
	
func process_movement(delta:float):
	dir.y = 0
	dir = dir.normalized()
	vel.y += delta * GRAVITY
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

#	hvel = hvel.lerp(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
