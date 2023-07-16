class_name SoundQueue
extends Node

var next_sound: AudioStreamPlayer
var current_sound: AudioStreamPlayer : set = _set_current_sound 
var transitioning = false

func _set_current_sound(s: AudioStreamPlayer):
	if current_sound:
		current_sound.finished.disconnect(_play_next)
	current_sound = s
	
	if current_sound:
		current_sound.finished.connect(_play_next)

func play_now(sound: AudioStreamPlayer):
	if sound == current_sound or transitioning: return
	
	transitioning = true
	if current_sound:
		print("Crossfading ", current_sound.name, ", ", sound.name)
		var tw = create_tween()
		tw.tween_property(current_sound, "volume_db", -10, 1.0)
		
		sound.volume_db = -10
		sound.play()
		tw.parallel().tween_property(sound, "volume_db", 0, 1.0)
		
		await tw.finished
		_stop_and_restore(current_sound)
	else:
		sound.play()
		
	self.current_sound = sound
	transitioning = false

func _stop_and_restore(sound: AudioStreamPlayer):
	sound.stop()
	sound.volume_db = 0

func queue(sound: AudioStreamPlayer):
	if current_sound:
		next_sound = sound
	else:
		self.current_sound = sound
		sound.play()

func _play_next():
	if next_sound:
		self.current_sound = next_sound
		current_sound.play()
		next_sound = null
	else:
		self.current_sound = null
