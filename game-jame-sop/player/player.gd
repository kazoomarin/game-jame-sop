extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

var isground = true

@onready var DUST = preload("res://tankiz/dust.tscn")

@onready var k = load("res://tankiz/dust.tscn") #ysib fi k effect ta3 tay5an player

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")




func _physics_process(delta):
	
	if  isground == false and is_on_floor() == true:
		var instance = DUST.instantiate()
		instance.global_position = $Marker2D.global_position
		get_parent().add_child(instance)
		print("ok")
	isground = is_on_floor()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	elif Input.is_action_just_pressed("ui_accept") and is_on_floor():
	
		velocity.y = JUMP_VELOCITY
		$AnimationPlayer.play("jumb")
		$tankyz.play()
		
		
	
	

	# Handle jump.


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.play("run")
		
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			$AnimatedSprite2D.play("idle")
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif  velocity.x > 0:
		$AnimatedSprite2D.flip_h = false



	move_and_slide()










