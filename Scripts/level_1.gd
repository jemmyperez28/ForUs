extends Node2D

var player_controls = {}  # Aquí se cargarán las configuraciones desde el archivo JSON

# Función que se ejecuta al iniciar la escena "Nivel 1"
func _ready():
	load_player_controls()  # Cargar configuraciones desde el JSON
	# Asignar controles a cada jugador
	$Player1.set_controls(player_controls["1"])
	$Player2.set_controls(player_controls["2"])
	$Player3.set_controls(player_controls["3"])

# Función para cargar las configuraciones de los jugadores desde el archivo JSON
func load_player_controls():
	var file_path = "user://configuracion_jugadores.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		# Crear una instancia de la clase JSON
		var json = JSON.new()
		var result = json.parse(json_data)
		
		if result == OK:
			player_controls = json.get_data()  # Cargar los controles del archivo JSON
			print("Configuraciones cargadas: ", player_controls)
		else:
			print("Error al cargar el archivo JSON.")
		
		file.close()
	else:
		print("No se pudo abrir el archivo JSON en la ruta: ", file_path)
