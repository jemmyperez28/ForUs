extends CharacterBody2D

# Constantes de movimiento
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Controles cargados desde el JSON
var controls = {}

# Función para asignar los controles personalizados desde el archivo JSON
func set_controls(control_data):
	controls = control_data
	print("Controles asignados para Player 1: ", controls)  # Imprimir los controles asignados para depuración

# Función que se ejecuta en cada frame (física)
func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += get_gravity().y * delta  # Usamos solo la componente Y de la gravedad

	# Manejar salto
	if Input.is_key_pressed(controls["up"]) or Input.is_joy_button_pressed(0, controls["up"]):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Obtener la dirección de entrada (movimiento izquierda/derecha)
	var direction := 0
	if Input.is_key_pressed(controls["left"]) or Input.is_joy_button_pressed(0, controls["left"]):
		direction = -1
	if Input.is_key_pressed(controls["right"]) or Input.is_joy_button_pressed(0, controls["right"]):
		direction = 1

	# Mover al jugador horizontalmente
	velocity.x = direction * SPEED

	# Aplicar movimiento y detectar colisiones
	move_and_slide()
