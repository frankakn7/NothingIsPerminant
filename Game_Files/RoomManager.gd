extends Node2D


var room_scene = load("res://Room.tscn")
var corridor_hor_scene = load("res://CorridorHorizontal.tscn")
var corridor_ver_scene = load("res://CorridorVertical.tscn")
var room_distance = 128

var room_layout = [	[1, 1, 1, 1], 
					[1, 1, 2, 1], 
					[1, 1, 1, 1] ]
					
var rooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	generateRooms()

func generateNeighbourRooms():
	pass

func generateRooms():
	for y in range(len(room_layout)):
		rooms.append([])
		for x in range(len(room_layout[y])):
			if room_layout[y][x] == 2:
				generateStartRoom(Vector2(x,y))
#			var room_instance = room_scene.instance()
#			room_instance.set_name("Room_%d_%d" % [x, y])
#			room_instance.id = Vector2(x,y)
#			add_child(room_instance)
#			room_instance.connect("player_entered", self, "on_Enter")
#			var room_x_offset = len(room_layout[y])
#			if room_x_offset % 2 == 1:
#				room_x_offset = room_x_offset - 1
#			room_x_offset = (room_x_offset / 2) * room_instance.tile_pixel_width * room_instance.max_width
#			var room_x_pos = room_instance.max_width * x * room_instance.tile_pixel_width + (room_distance * x) - room_x_offset
#
#			var room_y_offset = len(room_layout)
#			if room_y_offset % 2 == 1:
#				room_y_offset = room_y_offset - 1
#			room_y_offset = (room_y_offset / 2) * room_instance.tile_pixel_width * room_instance.max_height
#			var room_y_pos = room_instance.max_height * y * room_instance.tile_pixel_width + (room_distance * y) - room_y_offset
#			room_instance.position += Vector2(room_x_pos, room_y_pos)
#
#			# Horizontal Corridors
#			if x != 0:
#				var corridor_instance_h = corridor_hor_scene.instance()
#				corridor_instance_h.set_name("Corridor_%d_%d_H" % [x, y])
#				add_child(corridor_instance_h)
#				corridor_instance_h.position = Vector2(room_instance.position.x - room_distance, room_instance.position.y + room_distance)
#
#			# Vertical corridor isntance
#			if y != 0:
#				var corridor_instance_v = corridor_ver_scene.instance()
#				corridor_instance_v.set_name("Corridor_%d_%d_V" % [x, y])
#				add_child(corridor_instance_v)
#				corridor_instance_v.position = Vector2(room_instance.position.x + room_distance * 2 + (room_distance / 2), room_instance.position.y - room_distance)
#
#
#			room_instance.get_node("DebugControl/DebugRoomNB").text = "%d/%d" % [x, y]
#			rooms[y].append(room_instance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generateRoom(offsetVector, parentPosition, parentId):
	var room_id = parentId - offsetVector
	var room_instance = room_scene.instance()
	room_instance.set_name("Room_%d_%d" % [room_id.x,room_id.y])
	add_child(room_instance)
	room_instance.id = room_id
	var offset_to_parent_X = offsetVector.x * (room_instance.tile_pixel_width * room_instance.max_width + room_distance) 
	var offset_to_parent_Y = offsetVector.y * (room_instance.tile_pixel_width * room_instance.max_height + room_distance)
	var offset_to_room_center_X = (room_instance.tile_pixel_width * room_instance.max_width) / 2
	var offset_to_room_center_Y = (room_instance.tile_pixel_width * room_instance.max_height) / 2
	room_instance.global_position = Vector2(parentPosition.x + offset_to_room_center_X, parentPosition.y + offset_to_room_center_Y)  + Vector2(offset_to_parent_X - offset_to_room_center_X, offset_to_parent_Y - offset_to_room_center_Y)
	room_instance.connect("player_entered", self, "on_Enter")

func generateStartRoom(id):
	var room_instance = room_scene.instance()
	room_instance.set_name("Room_%d_%d" % [id.x,id.y])
	add_child(room_instance)
	room_instance.id = id
	var offsetX = (room_instance.tile_pixel_width * room_instance.max_width) / 2
	var offsetY = (room_instance.tile_pixel_width * room_instance.max_height) / 2
	room_instance.global_position = Vector2(0 - offsetX, 0 - offsetY)
	room_instance.connect("player_entered", self, "on_Enter")

func on_Enter(id, roomPos):
	print(id)
	generateRoom(Vector2(0,1), roomPos, id)
