extends CharacterBody2D

class_name bird

signal game_started

const FLAP_FORCE = -300
const MAX_SPEED = 400
const GRAVITY = 850
const ROTATION_SPEED = 3

var started = false
var process_input = true

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if jump_pressed():
		if not started:
			start()

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
	if velocity.y > 0:
		rotation_degrees = min(90, rotation_degrees + ROTATION_SPEED)

func done():
	process_input = false

func stop():
	$AnimatedSprite2D.stop()
	velocity = Vector2.ZERO

func start():
	$AnimatedSprite2D.play("fly")
	game_started.emit()
	started = true

func jump_pressed():
	return Input.is_action_just_pressed("ui_up")
