extends CharacterBody2D

var SPEED = 90
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	# Setting up gravity
	velocity.y += gravity * delta
	_animated_sprite.play("calm")
	if(chase == true):
		_animated_sprite.play("attack")
		player = get_node("../../Player")
		var direction = (player.position - self.position).normalized()
		if player.position.x + 728 <= self.position.x:
			# Player On left
			get_node("AnimatedSprite2D").flip_h = true
		else:
			# Player On Right
			get_node("AnimatedSprite2D").flip_h = false
		if get_node("AnimatedSprite2D").flip_h == false:
			velocity.x = (direction.x * -1) * SPEED
		else:
			velocity.x = direction.x * SPEED
	move_and_slide()
	
func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false



func _on_player_death_body_entered(body):
	if body.name == "Player":
		velocity.x = 0
		chase = false
		self.queue_free()
