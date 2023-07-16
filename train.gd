extends CharacterBody2D

@export var speed := 400
@export var accel := 30

@onready var driving_sound := $Driving
@onready var stop_sound := $Stop
@onready var start_sound := $Start
@onready var idle_sound := $Idle

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sound_queue: SoundQueue = $SoundQueue

func fade_out_start():
	var tw = create_tween()
	tw.tween_property(start_sound, "volume_db", -50, 1.0)
	tw.parallel().tween_property(driving_sound, "volume_db", -50, 1.0)
	tw.finished.connect(_finish_start)

func _finish_start():
	start_sound.stop()
	driving_sound.stop()

func fade_out_stop():
	var tw = create_tween()
	tw.tween_property(stop_sound, "volume_db", -50, 1.0)
	tw.parallel().tween_property(idle_sound, "volume_db", -50, 1.0)
	tw.finished.connect(_finish_stop)

func _finish_stop():
	stop_sound.stop()
	idle_sound.stop()
	
	
func _physics_process(delta):
	var motion = Input.get_action_strength("move_left")
	
	if motion > 0 and velocity.x == 0:
		anim.play("start")
	elif motion == 0 and velocity.x > 0:
		anim.play("stop")
	
	velocity.x = move_toward(velocity.x, speed * motion, accel * delta)
	move_and_slide()
