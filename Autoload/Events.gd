extends Node

signal win(rank)
signal death

func get_rank(min_m: int, mid_m: int, max_m: int, moves: int):
	if moves <= min_m:
		return "S"
	elif moves > min_m and moves <= mid_m:
		return "A"
	elif moves > mid_m and moves <= max_m:
		return "B"
	elif moves > max_m:
		return "F"
