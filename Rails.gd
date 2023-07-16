extends TileMap

@export var rails_amount := 100
@onready var notifier := $VisibleOnScreenNotifier2D

var tile = 0
var atlas = Vector2(0, 0)
var layer = 0

func _on_visible_on_screen_notifier_2d_screen_entered():
	var rect = get_used_rect()
	var last_x = rect.end.x
	var y_pos = rect.position.y
	
	for i in range(rails_amount):
		set_cell(layer, Vector2(last_x + i, y_pos), tile, atlas)
		
	notifier.position = map_to_local(Vector2(last_x + rails_amount - 5, y_pos))
