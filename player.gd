extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const DASH_SPEED = 800.0
const DASH_TIME = 0.2  # seconds

var is_dashing = false
var dash_timer = 0.0


func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle dash
	if Input.is_action_just_pressed("dash") and not is_dashing:
		is_dashing = true
		dash_timer = DASH_TIME
		# Dash in the direction of movement (defaults to right if no input)
		var dash_dir = Input.get_axis("left", "right")
		if dash_dir == 0:
			dash_dir = 1
		velocity.x = dash_dir * DASH_SPEED
		velocity.y = 0  # optional: cancel vertical momentum

	# If dashing, count down timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false

	# Normal movement (only if NOT dashing)
	if not is_dashing:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED - 100)

	move_and_slide()


func _input(_event):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
