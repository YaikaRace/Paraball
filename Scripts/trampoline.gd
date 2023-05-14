extends Area2D

@export var direction = Vector2.UP



func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.started:
			var impulse = Vector2(800, 800)
			if direction == Vector2.UP or direction == Vector2.DOWN:
				body.linear_velocity.y = 0
			elif direction == Vector2.LEFT or direction == Vector2.RIGHT:
				body.linear_velocity.x = 0
			$AnimationPlayer.play("jump")
			body.apply_central_impulse(impulse * direction)
			$AudioStreamPlayer.play()
		set_deferred("monitoring", false)
		get_tree().create_timer(0.5).timeout.connect(on_cooldown)

func on_cooldown():
	set_deferred("monitoring", true)
