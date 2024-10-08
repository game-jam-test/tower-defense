extends StaticBody2D
class_name TowerBase

enum damage_types {
	MAGIC
}

######### Tower Stats ###########
var weapon_damage: int			# How much damage the projectile deals
var weapon_speed: int			# How fast the projectile travels
var weapon_pierce: int			# How many enemies can the projectile pass through before being freed
var damage_type: String			# Type of damage dealt by the projectile (Magic)
var is_ranged: bool				# Is the weapon ranged?
var weapon_cooldown: float		# How long before the weapon is fired again
var weapon_life: float			# How long a projectile lives
#################################

var targetedEnemy: Enemy = null	# current target we are shooting at
var Weapon: Resource			# Weapon to are shooting
var weapon_timer : Timer
var can_shoot := true

func reset_weapon_timer() -> void:
	can_shoot = true

# towerRadius casted as Area2D to be able to use get_overlapping_bodies()
@onready var towerRadiusNode = get_node("TowerRadius") as Area2D

func _physics_process(_delta: float) -> void:
	if weapon_timer == null:
		weapon_timer = Timer.new()
		weapon_timer.one_shot = true
		weapon_timer.timeout.connect(self.reset_weapon_timer)
		self.add_child(weapon_timer)
	
	update_enemy_priority()
	shoot()

func update_enemy_priority() -> void:
	var highestProgress = -1.0
	var enemies = towerRadiusNode.get_overlapping_bodies()

	# If no enemies in range
	if enemies.is_empty():
		targetedEnemy = null
	# If enemies in range
	else:
		# Check for enemy farthest down and set them to current enemy
		for enemy in enemies:
			if enemy is Enemy:
				var enemyProgress = (enemy.get_parent() as PathFollow2D).get_progress()
				if enemyProgress > highestProgress:
					highestProgress = enemyProgress
					targetedEnemy = enemy

func shoot() -> void:
	# If there is an enemy to shoot, then shoot
	if (targetedEnemy != null) && can_shoot:
		can_shoot = false
		var weapon_instance = Weapon.instantiate()

		weapon_instance.weapon_damage = weapon_damage
		weapon_instance.weapon_speed = weapon_speed
		weapon_instance.weapon_pierce = weapon_pierce
		weapon_instance.damage_type = damage_type
		weapon_instance.is_ranged = is_ranged
		weapon_instance.weapon_life_span = weapon_life
		
		weapon_instance.global_position = self.position	# move weapon to marker
		# set weapon direction to enemy
		weapon_instance.weapon_direction = (targetedEnemy.global_position - self.global_position).normalized()
		self.get_parent().add_child(weapon_instance)	# add weapon to scene
		weapon_timer.start(weapon_cooldown)
