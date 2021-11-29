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

func generateRooms():
	for y in range(len(room_layout)):
		for x in range(len(room_layout[y])):
			if room_layout[y][x] == 2:
				generateStartRoom(Vector2(x,y))

func generateNeighbourRooms(id, roomPos):
	pass

func generateRoom(offsetVector, parentPosition, parentId):
	var room_id = parentId + offsetVector
	if room_id in rooms:
		return			#Room already exists
	var room_instance = room_scene.instance()
	room_instance.set_name("Room_%d_%d" % [room_id.x,room_id.y])
	add_child(room_instance)
	rooms.append(room_id)
	room_instance.id = room_id
	#offset to parent center
	var room_width = room_instance.tile_pixel_width * room_instance.max_width
	var room_height = room_instance.tile_pixel_width * room_instance.max_height
	var offset_to_parent_X = offsetVector.x * (room_width + room_distance) 
	var offset_to_parent_Y = offsetVector.y * (room_height + room_distance)
	#offset to self room center (to go from center to top left corner)
	var offset_to_room_center_X = (room_instance.tile_pixel_width * room_instance.max_width) / 2
	var offset_to_room_center_Y = (room_instance.tile_pixel_width * room_instance.max_height) / 2
	room_instance.global_position = Vector2(parentPosition.x + offset_to_room_center_X, parentPosition.y + offset_to_room_center_Y)  + Vector2(offset_to_parent_X - offset_to_room_center_X, offset_to_parent_Y - offset_to_room_center_Y)
	generateCorridors(room_instance.global_position, room_width, room_height, [offsetVector])
	room_instance.connect("player_entered", self, "on_Enter")
	room_instance.get_node("DebugControl/DebugRoomNB").text = "%d/%d" % [room_id.x, room_id.y]

func generateCorridor(roomPos, side, roomWidth, roomHeight):
	#1/2 of room width + distance 1/2
	var offsetX = side.x * ((roomWidth / 2) + room_distance / 2)
	var offsetY = side.y * ((roomHeight / 2) + room_distance / 2)
	var roomCenter = Vector2(roomPos.x + roomWidth / 2, roomPos.y + roomHeight / 2)
	var corridor = corridor_hor_scene.instance()
	add_child(corridor)
	corridor.global_position = Vector2(roomCenter.x + offsetX, roomCenter.y + offsetY)
	corridor.global_rotation = side.angle()

func generateCorridors(roomPos, roomWidth, roomHeight, exceptSides=[]):
	var sides = [Vector2(-1,0), Vector2(0,-1), Vector2(1,0), Vector2(0,1)]
	for side in sides:
		if side in exceptSides:
			continue
		generateCorridor(roomPos, side, roomWidth, roomHeight)
	
	

func generateStartRoom(id):
	var room_instance = room_scene.instance()
	room_instance.set_name("Room_%d_%d" % [id.x,id.y])
	add_child(room_instance)
	rooms.append(id)
	room_instance.id = id
	var room_width = room_instance.tile_pixel_width * room_instance.max_width
	var room_height = room_instance.tile_pixel_width * room_instance.max_height
	var offsetX = (room_width) / 2
	var offsetY = (room_height) / 2
	room_instance.global_position = Vector2(0 - offsetX, 0 - offsetY)
	room_instance.connect("player_entered", self, "on_Enter")
	generateCorridors(room_instance.global_position, room_width, room_height)
	room_instance.get_node("DebugControl/DebugRoomNB").text = "%d/%d" % [id.x, id.y]

func on_Enter(id, roomPos):
	print(rooms)
	generateRoom(Vector2(0,1), roomPos, id)
	generateRoom(Vector2(1,0), roomPos, id)
	generateRoom(Vector2(-1,0), roomPos, id)
	generateRoom(Vector2(0,-1), roomPos, id)
