extends CharacterBody2D

class_name bird

signal game_started

const FLAP_FORCE = -300
const MAX_SPEED = 400
const GRAVITY = 850
const ROTATION_SPEED = 3

var started = false
var process_input = false

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up") and process_input:
		if not started:
			$AnimatableBody2D.play("fly")
			game_started.emit()
			started = true
		jump()
	if not started:
		return

	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, MAX_SPEED)
	move_and_collide(velocity * delta)
	tilt()

func jump():
	velocity.y = FLAP_FORCE
	rotation_degrees = -30

func tilt():
	if velocity.y < 0 and rotation_degrees < 90:
		rotation_degrees = lerp(rotation_degrees, deg_to_rad(-30), ROTATION_SPEED)
	elif velocity.y < 0 and rotation_degrees > -30:
		rotation_degrees = lerp(rotation_degrees, deg_to_rad(90), ROTATION_SPEED)
	else:
		rotation_degrees = lerp(rotation_degrees, deg_to_rad(90), ROTATION_SPEED)

func done():
	process_input = false

func stop():
	$AnimatedSprite2D.stop()
	velocity = Vector2.ZERO
