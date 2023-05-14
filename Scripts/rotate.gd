extends Area2D

@export var player_rotation: float = 90.0


func _on_body_entered(body):
	if body.is_in_group("player") and body.started:
		$AnimationPlayer.play("rotate")
		$AudioStreamPlayer.play(1.5)
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(body, "linear_velocity", body.linear_velocity.rotated(deg_to_rad(player_rotation)), 0.2)
