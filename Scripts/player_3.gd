extends CharacterBody2D

# Constantes de movimiento
const SPEED = 100.0
const JUMP_VELOCITY = -300.0

# Diccionarios separados para los controles de teclado y joystick
var keyboard_controls = {}
var joystick_controls = {}
var input_type = ""  # Este valor será asignado al cargar los controles desde el JSON

# Variables de animación
var is_facing_right = true  # Para controlar la dirección a la que está mirando el personaje
var current_animation = ""  # La animación que se está reproduciendo actualmente (inicialmente vacía)
var is_attacking = false  # Si el personaje está atacando, no se deben cambiar otras animaciones

# Función para asignar los controles personalizados desde el archivo JSON
func set_controls(control_data):
	keyboard_controls = control_data.get("keyboard", {})
	joystick_controls = control_data.get("joystick", {})
	input_type = control_data.get("input_type", "")  # Se asigna dinámicamente de acuerdo a lo guardado en el JSON
	#print("Controles asignados para teclado: ", keyboard_controls)
	#print("Controles asignados para joystick: ", joystick_controls)
	#print("Tipo de entrada: ", input_type)

# Función que detecta si una acción específica se ha activado
func is_action_pressed(action: String) -> bool:
	if input_type == "joystick" and joystick_controls.has(action):
		return Input.is_joy_button_pressed(joystick_controls[action]["device"], joystick_controls[action]["button"])
	elif input_type == "keyboard" and keyboard_controls.has(action):
		return Input.is_key_pressed(keyboard_controls[action])
	return false

# Función para reproducir una animación solo si no se está reproduciendo ya
func play_animation(anim_name: String) -> void:
	if current_animation != anim_name:
		#print("Reproduciendo animación: ", anim_name)  # Debug para asegurarnos de que está llamando a la animación
		$Sprite2D/AnimationPlayer.play(anim_name)
		current_animation = anim_name

# Función para manejar la lógica de animación según el estado del personaje
func handle_animations(direction: int) -> void:
	if is_attacking:
		# Si el personaje está atacando, no interrumpimos la animación
		return

	# Si el personaje está en el aire
	if not is_on_floor():
		if velocity.y < 0:
			play_animation("jump_up")  # Si está subiendo
		else:
			play_animation("jump_down")  # Si está cayendo
	else:
		# Si está en el suelo y no está atacando
		if direction == 0:
			play_animation("idle")
		elif direction != 0:
			play_animation("run")

# Función que se ejecuta en cada frame (física)
func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += get_gravity().y * delta  # Usamos solo la componente Y de la gravedad

	# Manejar salto según el dispositivo que esté usando
	if is_action_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Obtener la dirección de entrada (movimiento izquierda/derecha)
	var direction := 0
	if is_action_pressed("left"):
		direction = -1
		# Voltear al personaje hacia la izquierda si no está mirando hacia allá
		if is_facing_right:
			$Sprite2D.flip_h = true  # Voltear horizontalmente el sprite
			is_facing_right = false
	elif is_action_pressed("right"):
		direction = 1
		# Voltear al personaje hacia la derecha si no está mirando hacia allá
		if not is_facing_right:
			$Sprite2D.flip_h = false  # Revertir la inversión horizontal
			is_facing_right = true

	# Mover al jugador horizontalmente
	velocity.x = direction * SPEED

	# Aplicar movimiento y detectar colisiones
	move_and_slide()

	# Manejar animaciones
	handle_animations(direction)

# Función que se llama cuando la escena está lista
func _ready():
	# Llamar directamente a la animación "idle" al iniciar y agregar un mensaje de debug
	#print("Iniciando animación idle al principio")
	play_animation("idle")  # Esto fuerza la reproducción de idle al principio

# Función para realizar un ataque
func perform_attack():
	if not is_attacking:
		is_attacking = true
		play_animation("attack")
		await $AnimationPlayer.animation_finished  # Espera a que termine la animación de ataque
		is_attacking = false
