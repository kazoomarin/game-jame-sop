extends Camera2D

var k = ""
var first_position = 0
signal start_anim
signal tnijm_ta3mil_pause
@onready var first_time_to_look = 0
@onready var do_time_to_look = 0
@onready var bdaa = false
@onready var timer:int = 0
@onready var label = %Label
@onready var timer2 = 0
@onready var animation_comp = false
@export var movement_data : PlayerMovement
@onready var animation_player = $"../../AnimationPlayer"
@onready var timer1 = $Timer
@onready var timer_sound = $"../../timer_sound"
@onready var end_timer = $"../../end_timer"
var timer_finched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible = true
	first_time_to_look = movement_data.time_to_look
	do_time_to_look = movement_data.time_to_look
	first_position = position.x
	await get_tree().create_timer(1).timeout
	timer1.start()
	pass # Replace with function body.
func _process(delta):
	
			
		
	
	if do_time_to_look > 0 and animation_comp == true:
		#get_tree().paused = true
		if get_local_mouse_position().x < 0 and position.x > movement_data.maxi_camira_left:
			position.x -= movement_data.camira_mouse_speed
		elif get_local_mouse_position().x > 0 and position.x < movement_data.maximal_camira_right:
			position.x += movement_data.camira_mouse_speed
	else :
		position.x = first_position
		#get_tree().paused = false
	if do_time_to_look <= 0:
		timer_finched = true
		label.visible = false
		tnijm_ta3mil_pause.emit()
	label.text =str(do_time_to_look)
	pass
func _physics_process(delta):


			
	

	
	pass
#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseMotion:
#		var _target = event.position - get_viewport().size * 0.5
#		print()
#		
#		if event.position.x <= 300:
#			self.position.x -= movement_data.camira_mouse_speed 
#		else :
#			self.position.x += movement_data.camira_mouse_speed  
#			

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_timer_timeout():
	if do_time_to_look > 0:
		do_time_to_look -= 1
		timer_sound.play()
		print(do_time_to_look)
	pass # Replace with function body.


func _on_animation_player_animation_finished():
	pass # Replace with function body.


func _on_world_finich_anim_debu():
	animation_comp = true
	pass # Replace with function body.
