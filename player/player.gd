extends KinematicBody

class_name Player

#member variables
export var speed = 16
export var gravity = 50
export var jump_height = 12
export var mode = "overworld"

var sprint_speed = 36
var attack = 0
var velocity = Vector3.ZERO

onready var health = get_node("HealthController")
onready var _camera_pivot = $CameraPivot
onready var armature = $rig
onready var anim_tree = $AnimationTree

onready var atkpivot = $AtkPivot
onready var lightatk = $AtkPivot/LightAtkArea

const LERP_VAL = 0.15

#signals
signal battleStart(id)
signal game_over


#Called when manipulating physics
func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if (mode == "overworld"):
		overworldMovement(direction, delta)
	elif (mode == "battle"):
		battleMovement(direction, delta)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(_delta):
#	_camera_pivot.translation = translation
	pass

func overworldMovement(direction, delta):
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
		if (direction != Vector3.ZERO):	
			anim_tree.set("parameters/world-movement/blend_amount", 1)
			anim_tree.set("parameters/run-time/scale", 2 + atan2(abs(velocity.x), abs(velocity.y))/sprint_speed)
	else:
		speed = 16
		anim_tree.set("parameters/world-movement/blend_amount", 0)
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Base.look_at(translation - direction, Vector3.UP)
#		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(velocity.x, velocity.z), LERP_VAL)
		armature.rotation.y = atan2(velocity.x, velocity.z)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_height
	
	velocity.x = lerp(velocity.x, direction.x * speed, LERP_VAL)
	velocity.z = lerp(velocity.z, direction.z * speed, LERP_VAL)
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	anim_tree.set("parameters/mode/current", 0)
	anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / speed)
	
	for index in range(get_slide_count()):
		var alert_collision = get_slide_collision(index)
		if alert_collision.collider.is_in_group("enemy_alert"):
			print("TRUE")
			var enemy = alert_collision.collider
			enemy.get_parent().detectPlayer(self.transform.origin)
	
func battleMovement(direction, delta):
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = 16
		
	if Input.is_action_just_pressed("light_attack"):
		anim_tree.set("parameters/is-attacking/current", 1)
		var state_machine = anim_tree.get("parameters/StateMachine/playback")
		state_machine.start("light-attack")
		$AtkPivot/LightAtkArea/LightHitbox.disabled = false
		
	if Input.is_action_just_pressed("heavy_attack"):
		pass
	if Input.is_action_just_pressed("guard"):
		pass
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
#		$Base.look_at(translation + direction, Vector3.UP)
		armature.rotation.y = atan2(velocity.x, velocity.z)
		atkpivot.rotation.y = atan2(velocity.x, velocity.z)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y += jump_height
	
	velocity.x = lerp(velocity.x, direction.x * speed, LERP_VAL)
	velocity.z = lerp(velocity.z, direction.z * speed, LERP_VAL)
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	anim_tree.set("parameters/mode/current", 1)
	anim_tree.set("parameters/battle-run/blend_position", velocity.length() / speed)

func startBattle(id):
	emit_signal("battleStart", id)
	
func receiveDamage(damage):
	health.receiveDamage(damage)

func _on_LightAtkArea_body_entered(body):
	var enemy = body
	var damage = attack + (1 * 2)
#	print("sent: " + str(damage))
	enemy.receiveDamage(damage)
	enemy.knockback(self.transform.origin)
	$AtkPivot/LightAtkArea/LightHitbox.disabled = true

func _on_BattleInitiator_body_entered(body):
	if (body.is_in_group("enemy") && mode != "battle"):
		var enemy = body
		var battle_id = enemy.getEnemyID()
		enemy.queue_free()
		startBattle(battle_id)
		$BattleInitiator/InitiatorShape.disabled = true

func _on_Player_battleStart(_id):
	mode = "battle"
