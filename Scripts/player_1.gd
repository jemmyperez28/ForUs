extends CharacterBody2D

# Constantes de movimiento
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Diccionarios separados para los controles de teclado y joystick
var keyboard_controls = {}
var joystick_controls = {}
var input_type = ""  # Este valor será asignado al cargar los controles desde el JSON

# Función para asignar los controles personalizados desde el archivo JSON
func set_controls(control_data):
	keyboard_controls = control_data.get("keyboard", {})
	joystick_controls = control_data.get("joystick", {})
	input_type = control_data.get("input_type", "")  # Se asigna dinámicamente de acuerdo a lo guardado en el JSON
	print("Controles asignados para teclado: ", keyboard_controls)
	print("Controles asignados para joystick: ", joystick_controls)
	print("Tipo de entrada: ", input_type)

# Función que se ejecuta en cada frame (física)
func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += get_gravity().y * delta  # Usamos solo la componente Y de la gravedad

	# Manejar salto según el dispositivo que esté usando
	if input_type == "joystick" and joystick_controls.has("up"):
		if Input.is_joy_button_pressed(joystick_controls["up"]["device"], joystick_controls["up"]["button"]) and is_on_floor():
			velocity.y = JUMP_VELOCITY
	elif input_type == "keyboard" and keyboard_controls.has("up"):
		if Input.is_key_pressed(keyboard_controls["up"]) and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Obtener la dirección de entrada (movimiento izquierda/derecha)
	var direction := 0
	if input_type == "joystick":
		if joystick_controls.has("left") and Input.is_joy_button_pressed(joystick_controls["left"]["device"], joystick_controls["left"]["button"]):
			direction = -1
		if joystick_controls.has("right") and Input.is_joy_button_pressed(joystick_controls["right"]["device"], joystick_controls["right"]["button"]):
			direction = 1
	elif input_type == "keyboard":
		if keyboard_controls.has("left") and Input.is_key_pressed(keyboard_controls["left"]):
			direction = -1
		if keyboard_controls.has("right") and Input.is_key_pressed(keyboard_controls["right"]):
			direction = 1

	# Mover al jugador horizontalmente
	velocity.x = direction * SPEED

	# Aplicar movimiento y detectar colisiones
	move_and_slide()
