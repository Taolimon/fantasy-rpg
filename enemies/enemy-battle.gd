extends KinematicBody

export (PackedScene) var player_scene

export var min_speed = 7
export var max_speed = 10
export var stance = 10
export var alerted = false

onready var player = null
onready var player_position = null
onready var normal_mat = $Base/MeshInstance.get_surface_material(0)
onready var health = get_node("HealthController")


var velocity = Vector3.ZERO
var downed = false

#signals
signal defeated
signal enemy_down

# warning-ignore:return_value_discarded
func _physics_process(_delta):
	var enemy_position = transform.origin
	
	if downed:
		pass
	
	#try to follow the player
	if (player != null && downed == false):	
		player_position = player.transform.origin
		var direction = (player_position - enemy_position).normalized()
		look_at_from_position(enemy_position, player_position, Vector3.UP)
		move_and_slide(direction * max_speed, Vector3.UP)
		
func knockback(knockback_origin):
	velocity.x = lerp(velocity.x, -((knockback_origin.x * min_speed) * 2), 0.1)
	velocity.z = lerp(velocity.z, -((knockback_origin.z * min_speed) * 2), 0.1)
	velocity.y = lerp(velocity.y + 1, velocity.y, 0.1)
	velocity = move_and_slide(velocity, Vector3.UP)

func receiveDamage(damage):
	var materialHit = $Base/MeshInstance.get_surface_material(0)
	materialHit.albedo_color = Color(0,0,0)
	$Base/MeshInstance.set_surface_material(0, materialHit)
	stance -= damage * 2
	health.receiveDamage(damage)
	checkStance()
	normalState()
	
		
func checkStance():
	if (stance <= 0):
		enemyDown()
		
func enemyDown():
	print("DOWN")
	downed = true
	emit_signal("enemy_down")
	

func normalState():
	$Base/MeshInstance.set_surface_material(0, normal_mat)
	

func detectPlayer(player_pos):
	player_position = player_pos
		
func endBattle():
	emit_signal("battleEnd")
	queue_free()
	
#Moves	
func attackPlayer():
	pass

func guard():
	pass
