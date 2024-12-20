extends Node

# Diccionarios para almacenar las acciones configuradas de los jugadores
var player_controls = {
	1: {"input_type": "keyboard", "keyboard": {}, "joystick": {}},
	2: {"input_type": "joystick", "keyboard": {}, "joystick": {}},
	3: {"input_type": "keyboard", "keyboard": {}, "joystick": {}}
}

# Lista de acciones que se van a configurar
var actions = ["up", "down", "left", "right", "action", "jump", "choose_skill", "use_skill"]

var current_player = 1  # Empezamos con el Player 1
var current_action_index = 0  # Índice de la acción actual a configurar
var waiting_for_input = false  # Indica si estamos esperando la entrada de una tecla/botón
var input_locked = false  # Controla si se está esperando que el jugador suelte la tecla o botón
var is_joystick_config = false  # Indica si estamos configurando joystick o teclado

# Función que se llama cuando la escena está lista
func _ready():
	show_next_action()
	# Imprimir los joysticks conectados
	var connected_joypads = Input.get_connected_joypads()
	var joypad_count = len(connected_joypads)
	$Label2.text = "Joysticks conectados: " + str(joypad_count)

# Muestra el texto de la próxima acción a configurar
func show_next_action():
	if current_player <= 3:
		if current_action_index < actions.size():
			var action_name = actions[current_action_index]
			$Label.text = "Configuración para Player " + str(current_player) + "\nIngrese " + action_name.capitalize() + ":"
			waiting_for_input = true
			input_locked = false  # Desbloquea la entrada para la nueva acción
		else:
			# Si ya se configuraron todas las acciones para el jugador actual, pasar al siguiente jugador
			current_action_index = 0
			current_player += 1
			show_next_action()
	else:
		# Si ya se configuraron los 3 jugadores, guardamos la configuración
		save_player_controls()
		$Label.text = "Configuración completa para todos los jugadores.\nDatos guardados."
		waiting_for_input = false

# Detecta la entrada del jugador (teclado o joystick)
func _input(event):
	if waiting_for_input and not input_locked:
		if event is InputEventKey and event.is_pressed():
			# Configurando controles de teclado
			var key = event.keycode
			var action_name = actions[current_action_index]
			player_controls[current_player]["keyboard"][action_name] = key  # Guarda en la parte de teclado
			player_controls[current_player]["input_type"] = "keyboard"  # El jugador usa teclado
			print("Tecla asignada para Player ", current_player, " en ", action_name, ": ", key)
			current_action_index += 1
			input_locked = true  # Bloquea nuevas entradas hasta que la tecla se suelte
			show_next_action()

		elif event is InputEventJoypadButton and event.is_pressed():
			# Configurando controles de joystick
			var joy_button = event.button_index
			var joy_device_id = event.device  # ID del joystick
			print("Asignando a Player", current_player, "con Joystick ID:", joy_device_id)

			var action_name = actions[current_action_index]
			player_controls[current_player]["joystick"][action_name] = {"button": joy_button, "device": joy_device_id}  # Guarda en joystick
			player_controls[current_player]["input_type"] = "joystick"  # El jugador usa joystick
			current_action_index += 1
			input_locked = true  # Bloquea nuevas entradas hasta que se suelte el botón
			show_next_action()

	if event is InputEventKey and not event.is_pressed():
		input_locked = false

	if event is InputEventJoypadButton and not event.is_pressed():
		input_locked = false

# Guarda las configuraciones en un archivo JSON
func save_player_controls():
	var file_path = "user://configuracion_jugadores.json"
	var file = FileAccess.open(file_path, FileAccess.WRITE)

	if file:
		var json_data = JSON.stringify(player_controls)  # Convierte el diccionario a formato JSON
		file.store_string(json_data)  # Almacena el contenido JSON en el archivo
		var absolute_path = file.get_path_absolute()  # Obtiene la ruta completa donde se guarda el archivo
		file.close()

		# Muestra la ruta completa donde se guardó el archivo
		print("Configuración guardada correctamente en: ", file_path)
		print("Ruta completa: ", absolute_path)
		get_tree().change_scene_to_file("res://Escenas/Menu_principal.tscn")
	else:
		print("No se pudo guardar el archivo en la ruta: ", file_path)
