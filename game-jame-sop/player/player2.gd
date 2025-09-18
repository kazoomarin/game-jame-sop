extends CharacterBody2D

@export var movement_data : PlayerMovement
signal player_is_spiked

# State variables
var was_wall_normal = Vector2.ZERO
var current_jump = 1
var just_wall_jumped = false
var air_jump = false
var is_jumping = false
var was_on_floor = true
var jump_started = false
var coyote_time = 0.1
var coyote_timer = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var landing_threshold = 50.0
var wall_jumb = false

# Node references
@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_animator = $AnimationPlayer
@onready var coyote_jump_timer = $coyote_jumb_timer
@onready var wall_jump_timer = $wallhumbtimer
@onready var jump_sound = $tankyz
@onready var name_animation: Label = $nameAnimation
@onready var name_animation_2: Label = $nameAnimation2


func _ready():
	print("5dimt")
	# Connect animation finished signal
	jump_animator.animation_finished.connect(_on_jump_animation_finished)

func _physics_process(delta):
	name_animation.text = animated_sprite.animation
	name_animation_2.text = jump_animator.current_animation
	# Update coyote timer
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	
	# Physics
	apply_gravity(delta)
	handle_jump()
	handle_wall_jump()
	
	# Movement
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_movement(input_axis, delta)
	handle_animations(input_axis)
	
	# State tracking
	was_on_floor = is_on_floor()
	move_and_slide()
	
	# Landing detection
	if not was_on_floor and is_on_floor() and is_jumping:
		play_landing_animation()
	
	# Coyote time
	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		coyote_jump_timer.start()

func _on_jump_animation_finished(anim_name):
	match anim_name:
		"jump_start":
			if not is_on_floor():
				jump_animator.play("jump_mid")
		"jump_mid":
			jump_animator.play("jump_mid_ball")
		"jump_end":
			complete_landing()

func handle_movement(input_axis, delta):
	if input_axis != 0:
		animated_sprite.flip_h = input_axis < 0
		var target_speed = input_axis * movement_data.speed
		
		if is_on_floor():
			velocity.x = move_toward(velocity.x, target_speed, movement_data.acc * delta)
		else:
			velocity.x = move_toward(velocity.x, target_speed, movement_data.air_acceration * delta)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func handle_jump():
	if is_on_floor(): 
		air_jump = true
	
	# Normal jump
	if (is_on_floor() or coyote_jump_timer.time_left > 0.0 or coyote_timer > 0):
		if Input.is_action_pressed("ui_accept") and not is_jumping: 
			start_jump()
	# Jump cut (short hop)
	elif not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < movement_data.jump_power / 2.0:
			velocity.y = movement_data.jump_power / 2.0
			
		# Air jump
		if Input.is_action_just_pressed("ui_accept") and air_jump and not just_wall_jumped:
			velocity.y = movement_data.jump_power * 0.8
			jump_sound.play()
			air_jump = false
			jump_animator.play("jump_start")

func start_jump():
	velocity.y = movement_data.jump_power
	coyote_jump_timer.stop()
	coyote_timer = 0.0
	jump_sound.play()
	is_jumping = true
	jump_started = true
	# Make sure sprite is visible
	animated_sprite.visible = true
	# Play jump animation through AnimationPlayer
	jump_animator.play("jump_start")

func play_landing_animation():
	if jump_animator.current_animation != "jump_end":
		jump_animator.play("jump_end")

func complete_landing():
	is_jumping = false
	jump_started = false
	# Return to appropriate ground animation
	if abs(velocity.x) > 10:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

func handle_wall_jump():
	if not is_on_wall_only(): return
	
	var wall_normal = get_wall_normal()
	jump_animator.play("wall_jump")
	
	if Input.is_action_just_pressed("ui_select"):
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_power
		just_wall_jumped = false
		is_jumping = true
		jump_animator.play("jump_mid")

func handle_animations(input_axis):
	# Don't override jump animations
	if is_jumping:
		return
	
	if is_on_wall():
		jump_animator.play("wall_jump")
	elif is_on_floor():
		if input_axis != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	elif not is_on_floor():
		animated_sprite.play("fall")

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity * delta
