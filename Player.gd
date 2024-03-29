extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)
const FIREBALL = preload("res://Fireball.tscn")
const FIREBALLRED = preload("res://FireballRed.tscn")

var velocity = Vector2()
var on_ground = true
var is_attacking = false
var is_dead = false
var fireball_power = 1

func _physics_process(delta):
	if not is_dead:
		if Input.is_action_pressed("ui_right"):
			if not is_attacking or not on_ground:
				velocity.x = SPEED
				if not is_attacking:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if not is_attacking or not on_ground:
				velocity.x = -SPEED
				if not is_attacking:
					$AnimatedSprite.play("run")
					$AnimatedSprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground and not is_attacking:
				$AnimatedSprite.play("idle")
		
		if Input.is_action_pressed("ui_accept"):
			if on_ground and not is_attacking:
				velocity.y = JUMP_POWER
				on_ground = false
		
		if Input.is_action_just_pressed("attack") and not is_attacking:
			if on_ground:
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("attack")
			var fireball = null
			if fireball_power == 1:
				fireball = FIREBALL.instance()
			elif fireball_power == 2:
				fireball = FIREBALLRED.instance()
			if sign($Position2D.position.x) == -1:
				fireball.set_fireball_direction(-1)
			get_parent().add_child(fireball)
			fireball.global_position = $Position2D.global_position
		
		velocity.y += GRAVITY
		
		if is_on_floor():
			if not on_ground:
				is_attacking = false
			on_ground = true
		else:
			on_ground = false
			if not is_attacking:
				if velocity.y < 0:
					$AnimatedSprite.play("jump")
				else:
					$AnimatedSprite.play("fall")
		
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()


func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()


func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")


func crown_power_up():
	fireball_power = 2