extends Button
tool

var save_filepath = "res://addons/Ross's Project Timer/time.sav"
var options_filepath = "res://addons/Ross's Project Timer/options.sav"

var t = 0
var pause_on_switch = true
var paused = false

var focused = false

func initialize():
	get_node("Label").set_text("Initializing...")
	get_node("Timer").connect("timeout", self, "timer_tick")
	connect("pressed", self, "button_pressed")
	get_node("Timer").start()
	load_time()
	load_options()

func _input_event(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.pressed and event.button_index == BUTTON_RIGHT:
		PauseResume_Button_pressed()
		accept_event()

func _notification(what):
	if not paused and pause_on_switch:
		if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			get_node("Timer").stop()
			get_node("AnimationPlayer").play("paused")
		elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
			# It's impossible to change pause_on_switch when the window is not in focus, 
			# so I won't ever need to resume on focus_in when pause_on_switch is false. 
			get_node("Timer").start()
			get_node("AnimationPlayer").stop_all()
			get_node("Label").set_opacity(1.0)

func timer_tick():
	t += 1
	update_text()

func get_time_string():
	var s1 = t % 10
	var s10 = ((t - s1) % 60)/10
	var m1 = int(t/60) % 10
	var m10 = (int((t - m1)/60) % 60 )/10
	var h = int(t/3600)
	
	var string = str(h) + ":" + str(m10) + str(m1) + ":" + str(s10) + str(s1)
	return string

func update_text():
	if t < 0: t = 0
	get_node("Label").set_text(get_time_string())

func load_time():
	var save = File.new()
	if not save.file_exists(save_filepath):
		print("(Ross's Project Timer) No save file, creating a new one . . . ")
		save_time()
	save.open(save_filepath, File.READ)
	t = save.get_64()
	save.close()
	print("(Ross's Project Timer) Loading . . . Time: ", t)

func save_time():
	var save = File.new()
	save.open(save_filepath, File.WRITE)
	save.store_64(t)
	save.close()
	print("(Ross's Project Timer) Saving . . . Time: ", t)

func load_options():
	var save = File.new()
	if not save.file_exists(options_filepath):
		save_options()
	save.open(options_filepath, File.READ)
	var l = {}
	save.seek(0)
	l.parse_json(save.get_line())
	pause_on_switch = l["pause on switch"]
	get_node("Menu/GridBox/Switch-Pause Toggle").set_pressed(pause_on_switch)
	save.close()

func save_options():
	var save = File.new()
	save.open(options_filepath, File.WRITE)
	var l = {"pause on switch": pause_on_switch}
	save.seek(0)
	save.store_line(l.to_json())
	save.close()

func _exit_tree():
	save_time()
	save_options()

func button_pressed():
	get_node("Menu").popup()
	get_node("Menu").set_global_pos(get_global_pos() - Vector2(0, -26))

func Reset_Button_pressed():
	get_node("ResetConfirm").popup()
	get_node("ResetConfirm").set_global_pos(get_global_pos() + Vector2(-330, 52))

func ResetConfirm_confirmed():
	t = 0
	update_text()

func Close_Button_pressed():
	get_node("Menu").hide()

func Add_Time_Button_pressed():
	var time = get_node("Menu/GridBox/Add Time Button/Time SpinBox").get_value()
	time = int(time) * 60
	t += time
	update_text()

func PauseResume_Button_pressed():
	if get_node("Timer").is_processing():
		get_node("Timer").stop()
		paused = true
		get_node("Menu/GridBox/Pause-Resume Button").set_text("Resume")
		get_node("AnimationPlayer").play("paused")
	else:
		get_node("Timer").start()
		paused = false
		get_node("Menu/GridBox/Pause-Resume Button").set_text("Pause")
		get_node("AnimationPlayer").stop_all()
		get_node("Label").set_opacity(1.0)

func SwitchPause_Toggle_pressed():
	pause_on_switch = get_node("Menu/GridBox/Switch-Pause Toggle").is_pressed()
