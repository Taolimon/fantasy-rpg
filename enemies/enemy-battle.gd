extends KinematicBody

export (PackedScene) var player_scene

export var min_speed = 7
export var max_speed = 14
export var stance = 10
export var alerted = false

onready var player = null
onready var player_position = null
onready var normal_mat = $Base/MeshInstance.get_surface_material(0)
onready var normal_colour = normal_mat.albedo_color
onready var health = get_node("HealthController")
onready var behaviour = get_node("EnemyBehaviour")

var velocity = Vector3.ZERO
var speed = min_speed
var downed = false
var timer = 0

#signals
signal defeated
signal enemy_down

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
			speed = -12
			print(str(speed))
			if (timer > 12):
				resetTimer(timer)
		behaviour.STATES.ADVANCING:
			speed = max_speed
		behaviour.STATES.ATTACKING:
			attackPlayer()
		behaviour.STATES.GUARDING:
			if (timer < 2):
				guard()
			else:
				resetTimer(timer)
		behaviour.STATES.DOWNED:
			print("CURRENT STATE: " + str(behaviour.getState()))
			if (timer > 4):
				resetTimer(timer)
				stance = 10
			else:
				speed = 0
		_:
			pass
			
			
			
	#try to follow the player
	if (player != null && behaviour.getState() != behaviour.STATES.DOWNED):	
		player_position = player.transform.origin
		var direction = (player_position - enemy_position).normalized()
		look_at_from_position(enemy_position, player_position, Vector3.UP)
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
		damage = damage / 2
	
	var materialHit = $Base/MeshInstance.get_surface_material(0)
	materialHit.albedo_color = Color(0,0,0)
	$Base/MeshInstance.set_surface_material(0, materialHit)
	stance -= damage * 2
	health.receiveDamage(damage)
	checkStance()
	normalState()

func checkDamage():
	var received_damage
	if (received_damage > health.health/3):
		behaviour.setState(behaviour.AFFLICTIONS.HEAVY_DAMAGE)
	else:
		behaviour.setState(behaviour.AFFLICTIONS.LIGHT_DAMAGE)
		
func checkStance():
	if (stance <= 0):
		enemyDown()
		
func enemyDown():
	print("DOWN")
	behaviour.setState(behaviour.STATES.DOWNED)
	downed = true
	emit_signal("enemy_down")
	

func normalState():
	normal_mat.albedo_color = normal_colour
	

func detectPlayer(p):
	player = p
		
func endBattle():
	emit_signal("battleEnd")
	queue_free()
	
#Moves	
func attackPlayer():
	pass

func guard():
	pass

#func backoff(t):
#	var backoff_direction = player.transform.origin.direction_to(self.transform.origin)
#	if (t < 60):
#		transform.origin += backoff_direction * speed
#		return false
#	else:
#		return true
	
func resetTimer(t):
	t = 0
	behaviour.setState(behaviour.STATES.NORMAL)

func _on_HealthController_half_health():
	behaviour.setState(behaviour.STATES.WARY)
