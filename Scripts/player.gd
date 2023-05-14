extends RigidBody2D

var explosion_particles = preload("res://Scenes/explosion.tscn")

var orbiting = false
var started = false
var can_move = true

var center_position = Vector2(720, 248)
var prev_vel: Vector2
var potencia = 0.0
var moves = 0
var pressed_area = Vector2(0, 0)
@export_range(-360, 360) var line_rotation: float = 0.0

var colors = {
	green = Color(0.43529412150383, 0.78039216995239, 0.68235296010971),
	yellow = Color(0.78039216995239, 0.70980393886566, 0.43529412150383),
	red = Color(0.78039216995239, 0.43529412150383, 0.43529412150383)
}

func _ready() -> void:
	Transition.play("init")
	Events.win.connect(on_win)
	$Line2D.rotation_degrees = line_rotation

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		Transition.play("end")
		await Transition.animation_finished
		get_tree().reload_current_scene()
	can_move = !PauseMenu.visible
	await get_tree().process_frame
	if can_move:
		potency_control()
		if is_instance_valid($Circle2D2):
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
			tween.tween_property($Circle2D2, "position", linear_velocity.normalized() * Vector2(16, 16), 0.2)
		if %cooldown.is_stopped():
			move_ctrl()
		timer_ctrl()

func _integrate_forces(state):
	rotation_degrees = 0

func timer_ctrl() -> void:
	if started:
		if (linear_velocity.x <= 5 and linear_velocity.x >= -5) and (linear_velocity.y <= 5 and linear_velocity.y >= -5):
			if %restart_timer.is_stopped():
				%restart_timer.start()
		else:
			%restart_timer.stop()

func potency_control() -> void:
	if not started:
		if Input.is_action_pressed("l_click"):
			var distance = global_position.distance_to(get_global_mouse_position())
			$Line2D.look_at(get_global_mouse_position())
			$Line2D.remove_point(1)
			$Line2D.add_point(Vector2(distance/5, 0))
			if distance >= 0.0 and distance <= 333.0:
				$Line2D.default_color = colors.green
			elif distance >= 334.0 and distance <= 666.0:
				$Line2D.default_color = colors.yellow
			elif distance >= 667.0:
				$Line2D.default_color = colors.red
		elif Input.is_action_just_released("l_click"):
			potencia = global_position.distance_to(get_global_mouse_position()) * 1.15
			freeze = false
			var impulse = Vector2(potencia, potencia)
			var direction = global_position.direction_to(get_global_mouse_position()).rotated(deg_to_rad(180))
			await get_tree().process_frame
			apply_central_impulse(impulse * direction)
			started = true
		elif Input.is_action_pressed("up"):
			$Line2D.rotation_degrees += 2.5
		elif Input.is_action_pressed("down"):
			$Line2D.rotation_degrees += -2.5
		if Input.is_action_pressed("ui_accept"):
			potencia += 10
			potencia = clamp(potencia, 0, 1200)
			$Line2D.remove_point(1)
			$Line2D.add_point(Vector2(potencia/5, 0))
			if potencia >= 0.0 and potencia <= 333.0:
				$Line2D.default_color = colors.green
			elif potencia >= 334.0 and potencia <= 666.0:
				$Line2D.default_color = colors.yellow
			elif potencia >= 667.0:
				$Line2D.default_color = colors.red
		elif Input.is_action_just_released("ui_accept"):
			freeze = false
			var impulse = Vector2(potencia, potencia)
			var angle = $Line2D.rotation
			var direction = Vector2(cos(angle), sin(angle))
			await get_tree().process_frame
			apply_central_impulse(impulse * -direction)
			started = true
	else:
		$Line2D.visible = false

func move_ctrl() -> void:
	if started:
		if Input.is_action_just_pressed("l_click"):
			pressed_area = get_global_mouse_position()
		if Input.is_action_just_pressed("right") or (Input.is_action_just_pressed("l_click") and pressed_area.x > 540):
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(self, "linear_velocity", linear_velocity.rotated(deg_to_rad(90)), 0.2)
			moves += 1
			%cooldown.start()
			%boomerang.play()
		elif Input.is_action_just_pressed("left") or (Input.is_action_just_pressed("l_click") and pressed_area.x < 540):
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(self, "linear_velocity", linear_velocity.rotated(deg_to_rad(-90)), 0.2)
			moves += 1
			%cooldown.start()
			%boomerang.play()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("danger"):
		var explosion = explosion_particles.instantiate()
		explosion.global_position = global_position
		get_parent().add_child(explosion)
		set_deferred("freeze", true)
		visible = false
		Events.death.emit()
		%explosion.play()
		Transition.play("end")
		await Transition.animation_finished
		get_tree().reload_current_scene()

func on_win(_rank):
	started = false
	contact_monitor = false
	set_deferred("freeze", true)
	get_tree().paused = true


func _on_restart_timer_timeout() -> void:
	Transition.play("end")
	await  Transition.animation_finished
	get_tree().reload_current_scene()
