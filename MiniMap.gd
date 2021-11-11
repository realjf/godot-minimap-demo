extends MarginContainer

export (NodePath) var player
export var zoom = 1.5 setget set_zoom

onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/PlayerMarker
onready var mob_marker = $MarginContainer/Grid/MobMarker
onready var alert_marker = $MarginContainer/Grid/AlertMarker

# TODO: you need add enemies group with "minimap_objects" and set "minimap_icon='mob'" in its script
# Also: you can add alert thing group with "minimap_objects" and set "minimap_icon='alert'" in its script
onready var icons = { "mob": mob_marker, "alert": alert_marker }


var grid_scale
var markers = {}

func _ready():
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker
	
	
func _process(delta):
	if !player:
		return
	
	for item in markers:
		var obj_pos = (item.position - get_node(player).position) * grid_scale + grid.rect_size / 2
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(0.02, 0.02)
		else:
			markers[item].scale = Vector2(0.01, 0.01)
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		markers[item].position = obj_pos
		
	
func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)




func _on_MiniMap_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom += 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom -= 0.1

		
		
		
		
