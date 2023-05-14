@tool
extends Polygon2D
class_name Circle2D

@export var radius: float = 50:
	set(new_radius):
		radius = new_radius
		create_circle()
@export var num_sides: int = 30:
	set(new_sides):
		num_sides = new_sides
		create_circle()
@export var pos: Vector2 = Vector2.ZERO:
	set(new_pos):
		pos = new_pos
		create_circle()

func create_circle():
	var poly: Array = []
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	for _i in num_sides:
		poly.append(vector + pos)
		vector = vector.rotated(angle_delta)
	polygon = poly
