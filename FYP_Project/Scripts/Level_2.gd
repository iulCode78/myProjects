extends Node2D

@export var level_number = 2

var Room = preload("res://Scenes/Room.tscn")
var Player = preload("res://Scenes/Player.tscn")
var exitDoor = preload("res://Scenes/Door.tscn")
var font
@onready var map = $TileMap

var tile_size = 32
var num_rooms = 100
var min_size = 6
var max_size = 15
var h_spread = 300
var cull = 0.5

var path #AStar pathfinding object
var start_room = null
var end_room = null
var play_mode = false
var player = null
var exit = null

func _ready():
	randomize()
	room_maker()
	#map_maker()
	font = ThemeDB.fallback_font;
	
func room_maker():
	for i in range(num_rooms):
		var pos = Vector2(randf_range(-h_spread, h_spread), 0)
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	#Wait for movement to stop
	await(get_tree().create_timer(0.4).timeout)
	#Cull rooms (deleting rooms)
	var room_pos = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			#room.freeze_mode.FREEZE_MODE_STATIC
			room.freeze = true
			room_pos.append(Vector2(room.position.x, room.position.y))
	await(get_tree().create_timer(0.2).timeout)
	#Generate a minimum spanning tree connecting the rooms
	path = find_minimum_tree(room_pos)
	map_maker()

func _draw_room():
	if play_mode:
		return
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size + room.size / 2, room.size), Color(0, 1, 0), false)
	if path:
		for p in path.get_point_ids():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(pp, cp, Color(1, 1, 0), 15, true)
				
func _process(delta):
	queue_redraw()
	
func _input(event):
	# Spacebar restarts and creates a new set of rooms
	if event.is_action_pressed('ui_select'):
		if play_mode:
			player.queue_free()
			exit.queue_free()
			play_mode = false
		map.clear()
		for n in $Rooms.get_children():
			n.queue_free()
		path = null
		start_room = null
		end_room = null
		room_maker()
	# Tab generates the TileMap
	#if event.is_action_pressed('make map'):
	if await(get_tree().create_timer(0.4).timeout):
		map_maker()
	# Esc spawns a player to explore the map
	#if event.is_action_pressed('ui_cancel'):
func add_player():
	player = Player.instantiate()
	add_child(player)
	player.position = start_room.position
	exit = exitDoor.instantiate()
	add_child(exit)
	exit.position = end_room.position
	play_mode = true
	
func find_minimum_tree(nodes):
	# Prim's Algorithm
	# Given an array of positions (nodes), generates a minimum spanning tree
	# Returns an AStar object
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF #  Minimum distance so far
		var min_p = null # Position of that node
		var p = null # Current position
		# Loop through points in path
		for p1 in path.get_point_ids():
			var p_temp = path.get_point_position(p1)
			# Loop through the remaining nodes
			for p2 in nodes:
				if p_temp.distance_to(p2) < min_dist:
					min_dist = p_temp.distance_to(p2)
					min_p = p2
					p = p_temp
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	return path
		
func map_maker():
	# Create a TileMap from the generated rooms and path
	map.clear()
	find_start_room()
	find_end_room()
	
	# Fill tilemap with walls, then carve empty rooms
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position - room.size, 
					room.get_node("CollisionShape2D").shape.extents * 10)
		full_rect = full_rect.merge(r)
	var top_left = map.local_to_map(full_rect.position)
	var bottom_right = map.local_to_map(full_rect.end)
	for x in range(top_left.x, bottom_right.x):
		for y in range(top_left.y, bottom_right.y):
			map.set_cell(0, Vector2i(x, y), 1, Vector2i(0, 0), 0) #Fills the background with tile 1
	
	# Carve rooms
	var corridor = [] # One corridor per connection
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				map.set_cell(0, Vector2i(ul.x + x, ul.y + y), 0, Vector2i(0, 0), 0) # Fills the rooms with tile 0
		# carve connection corridor
		var p = path.get_closest_point(room.position)
		for conn in path.get_point_connections(p):
			if not conn in corridor:
				var start = map.local_to_map(Vector2(path.get_point_position(p).x,
					  path.get_point_position(p).y))
				var end = map.local_to_map(Vector2(path.get_point_position(conn).x,
					  path.get_point_position(conn).y))
				carve_corridor(start, end)
		corridor.append(p)
		room.get_node("CollisionShape2D").disabled = true
	add_player()
				
func carve_corridor(start, end):
	# Carve a path between two points
	var x_diff = sign(end.x - start.x)
	var y_diff = sign(end.y - start.y)
	
	if x_diff == 0:
		x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0:
		y_diff = pow(-1.0, randi() % 2)
		
	var x_y = start
	var y_x = end
	
	if randi() % 2 > 0:
		x_y = end
		y_x = start
		
	for x in range(start.x, end.x, x_diff):
		#await get_tree().process_frame
		map.set_cell(0, Vector2i(x, x_y.y), 0, Vector2i(0, 0), 0);
		map.set_cell(0, Vector2i(x, x_y.y + y_diff), 0, Vector2i(0, 0), 0);
		#map.set_cells_terrain_connect(0, [Vector2i(x, y_x.y)], 0, 0)
	for y in range(start.y, end.y, y_diff):
		#await get_tree().process_frame
		map.set_cell(0, Vector2i(y_x.x, y), 0, Vector2i(0, 0), 0);
		map.set_cell(0, Vector2i(y_x.x + x_diff, y), 0, Vector2i(0, 0), 0);
		#map.set_cells_terrain_connect(0, [Vector2i(x_y.x, y)], 0, 0)
	
func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x

