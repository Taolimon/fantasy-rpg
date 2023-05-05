extends KinematicBody

export (PackedScene) var player_scene

export var enemy_name = "base"
export var attack = 0
export var min_speed = 7
export var max_speed = 14
export var gravity = 9.8
export var stance = 10
export var alerted = false
export var entity_level = 0

onready var player = null
onready var player_position = null
onready var normal_mat = $Base/MeshInstance.get_surface_material(0)
onready var normal_colour = normal_mat.albedo_color
onready var health = get_node("HealthController")
onready var behaviour = get_node("EnemyBehaviour")

onready var atkpivot = get_node("AtkPivot")
onready var lightatk = get_node("AtkPivot/LightAtkArea/LightHitbox")

onready var armature = $Armature
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")


var velocity = Vector3.ZERO
var speed = min_speed
var downed = false
var timer = 0
var start_time = 0

#signals
signal defeated
signal enemy_down

func _ready():
	playback.start("walk-loop")
	anim_tree.active = true

# warning-ignore:return_value_discarded
func _physics_process(delta):
	var enemy_position = transform.origin
	timer += delta
	
	match behaviour.state:
		behaviour.STATES.NORMAL:
			speed = min_speed
			normalState()
		behaviour.STATES.WARY:
#			print("CURRENT STATE: " + str(behaviour.getState()))
#			print("huh: " + str(backoff(timer)))
#			if (backoff(timer) == true):
#				resetTimer(timer)
			playback.travel("wary-loop")
			speed = -12
			if (timer > 2):
				resetTimer()
		behaviour.STATES.ADVANCING:
			speed = max_speed
		behaviour.STATES.ATTACKING:
			speed = min_speed
			if (behaviour.state != behaviour.STATES.ATTACKING):
				start_time = 0
				resetTimer()
			else:
				if (start_time == 0):
#					print("current_time: " + str(timer))
					start_time = round(timer)
					
#				print(str(timer))
#				print(str(start_time + 1))
				
				if (round(timer) == (start_time + 1)):
					timer = 0
					start_time = 0
					attackPlayer()
				else:
					playback.travel("walk-loop")
		behaviour.STATES.GUARDING:
			if (timer < 6):
				guard()
			else:
				resetTimer()
		behaviour.STATES.DOWNED:
#			print("CURRENT STATE: " + str(behaviour.getState()))
			if (timer > 3):
				resetTimer()
				stance = 10
			else:
				playback.travel("downed")
				speed = 0
		_:
			pass
			
			
			
	#try to follow the player
	if (player != null && behaviour.getState() != behaviour.STATES.DOWNED):	
		player_position = player.transform.origin
		var direction = (player_position - enemy_position).normalized()
		if (behaviour.state == behaviour.STATES.WARY):
			direction.y += gravity * delta
		else:
			direction.y -= gravity * delta
		look_at_from_position(enemy_position, player_position, Vector3.UP)
		atkpivot.look_at(player_position, Vector3.UP)
		move_and_slide(direction * speed, Vector3.UP)
		
func knockback(knockback_origin):
#	velocity.x = lerp(velocity.x, -((knockback_origin.x * min_speed) * 2), 0.1)
#	velocity.z = lerp(velocity.z, -((knockback_origin.z * min_speed) * 2), 0.1)
#	velocity.y = lerp(velocity.y + 1, velocity.y, 0.1)
	var knockback_result = knockback_origin.direction_to(self.transform.origin)
	transform.origin += knockback_result
#	velocity = move_and_slide(knockback_result, Vector3.UP)

func receiveDamage(damage):
	if (behaviour.getState() == behaviour.STATES.GUARDING):
		playback.travel("guard")
		damage = damage / 2
	else:
		playback.travel("hit")
	
	var materialHit = $Base/MeshInstance.get_surface_material(0)
	materialHit.albedo_color = Color(0,0,0)
	$Base/MeshInstance.set_surface_material(0, materialHit)
	stance -= damage * 2
	health.receiveDamage(damage)
	checkStance()
	normalState()

func checkDamage(received_damage):
	if (received_damage > health.health/3):
		behaviour.setState(behaviour.AFFLICTIONS.HEAVY_DAMAGE)
	else:
		behaviour.setState(behaviour.AFFLICTIONS.LIGHT_DAMAGE)
		
func checkStance():
	if (stance <= 0):
		enemyDown()
		
func enemyDown():
#	print("DOWN")
	behaviour.setState(behaviour.STATES.DOWNED)
	downed = true
	emit_signal("enemy_down")
	

func normalState():
	normal_mat.albedo_color = normal_colour
	playback.travel("walk-loop")
	

func detectPlayer(p):
	player = p
		
func endBattle():
	emit_signal("battleEnd")
	queue_free()
	
#Moves	
func attackPlayer():
	lightatk.disabled = false
	playback.travel("attacking")

func guard():
	pass

#func backoff(t):
#	var backoff_direction = player.transform.origin.direction_to(self.transform.origin)
#	if (t < 60):
#		transform.origin += backoff_direction * speed
#		return false
#	else:
#		return true

func setTimer(t, time):
	if (t > time):
		return true
	else:
		return false

func resetTimer():
	timer = 0
	start_time = 0
	behaviour.setState(behaviour.STATES.NORMAL)
	playback.travel("walk-loop")

func _on_HealthController_half_health():
	behaviour.setState(behaviour.STATES.WARY)


func _on_AtkRange_body_entered(body):
	if (body.is_in_group("player")):
		behaviour.setState(behaviour.STATES.ATTACKING)


func _on_LightAtkArea_body_entered(body):
	if (body == player):
		var damage = attack + (1 + (entity_level * 2))
#		print("ENEMY sent: " + str(damage))
		player.receiveDamage(damage)
		lightatk.disabled = true

func _on_LightAtkArea_body_exited(body):
	timer = 2
	lightatk.disabled = true
