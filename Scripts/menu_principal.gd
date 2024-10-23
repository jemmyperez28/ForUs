extends Node2D

# Función que se ejecuta cuando la escena está lista
func _ready():
# Conectar los botones a sus respectivas funciones
	$VBoxContainer/Button.connect("pressed", Callable(self, "_on_nueva_partida_pressed"))
	$VBoxContainer/Button2.connect("pressed", Callable(self, "_on_configurar_mando_pressed"))
	$VBoxContainer/Button3.connect("pressed", Callable(self, "_on_salir_pressed"))

# Función para "Nueva Partida"
func _on_nueva_partida_pressed():
	print("Iniciar nueva partida")
	# Aquí puedes cargar la escena de tu juego
	# Ejemplo: get_tree().change_scene_to_file("res://path_to_your_game_scene.tscn")
	get_tree().change_scene_to_file("res://Escenas/Level1.tscn")
# Función para "Configurar Mando"
func _on_configurar_mando_pressed():
	print("Abrir Configuración de Mando")
	get_tree().change_scene_to_file("res://Escenas/Configuracion_jostycks.tscn")
# Función para "Salir"

func _on_salir_pressed():
	print("Salir del juego")
	get_tree().quit()
