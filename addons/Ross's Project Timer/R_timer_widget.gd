extends Button
tool

var save_filepath = "res://addons/Ross's Project Timer/time.sav"
var options_filepath = "res://addons/Ross's Project Timer/options.sav"

var t = 0
var manually_paused = false

# Options vars
var pause_on_switch = true
var use_pause_anim = true
var show_seconds = true
var only_show_mouseover = false

var options = ["pause on switch", "use pause anim", "show seconds", "only show on mouseover"]

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
	if pause_on_switch and not manually_paused:
		if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
			pause()
		elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
			# Note: It's impossible to change pause_on_switch when the window is not in focus, 
			# so likewise I won't ever need to resume when the window is not in focus. 
			resume()

func timer_tick():
	t += 1
	update_text()

func update_text():
	if t < 0: t = 0
	get_node("Label").set_text(get_time_string())

func get_time_string():
	var s1 = t % 10
	var s10 = ((t - s1) % 60)/10
	var m1 = int(t/60) % 10
	var m10 = (int((t - m1)/60) % 60 )/10
	var h = int(t/3600)
	
	var string = str(h) + ":" + str(m10) + str(m1)
	if show_seconds: string += ":" + str(s10) + str(s1)
	return string

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
	var data = {}
	data.parse_json(save.get_line())
	for k in data.keys():
		set(k, data[k])
	# Update buttons and stuff to match settings:
	get_node("Menu/GridBox/Switch-Pause Toggle").set_pressed(pause_on_switch)
	get_node("Menu/GridBox/Use-Anim Toggle").set_pressed(use_pause_anim)
	get_node("Menu/GridBox/Show Seconds Toggle").set_pressed(show_seconds)
	update_text()
	get_node("Menu/GridBox/Only-Mouseover Toggle").set_pressed(only_show_mouseover)
	get_node("Label").set_hidden(only_show_mouseover)
	get_node("Timer Icon").set_hidden(not only_show_mouseover)
	
	save.close()

func save_options():
	var save = File.new()
	save.open(options_filepath, File.WRITE)
	var data = {"pause_on_switch"	 : pause_on_switch, 
				"use_pause_anim"	 : use_pause_anim,
				"show_seconds"		 : show_seconds,
				"only_show_mouseover": only_show_mouseover}
	save.store_line(data.to_json())
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
		pause()
		manually_paused = true
	else:
		resume()
		manually_paused = false

func pause():
	get_node("Timer").stop()
	get_node("Pause Icon").show()
	get_node("Menu/GridBox/Pause-Resume Button").set_text("Resume")
	if use_pause_anim: 
		if not get_node("AnimationPlayer").is_playing(): # so it can be called while paused with no jumps
			get_node("AnimationPlayer").play("paused")
	else:
		get_node("Label").set_opacity(0.4)
		get_node("AnimationPlayer").stop_all() # since changing use_anim depends on this to update things
		get_node("Timer Icon").set_opacity(0.4)

func resume():
	if not get_node("Timer").is_processing():
		get_node("Timer").start()
	get_node("Pause Icon").hide()
	get_node("Menu/GridBox/Pause-Resume Button").set_text("Pause")
	get_node("AnimationPlayer").stop_all()
	get_node("Label").set_opacity(1.0)
	get_node("Timer Icon").set_opacity(1.0)

func SwitchPause_Toggle_pressed():
	pause_on_switch = get_node("Menu/GridBox/Switch-Pause Toggle").is_pressed()

func UseAnim_Toggle_pressed():
	use_pause_anim = get_node("Menu/GridBox/Use-Anim Toggle").is_pressed()
	if manually_paused:
		pause()

func Show_Seconds_Toggle_pressed():
	show_seconds = get_node("Menu/GridBox/Show Seconds Toggle").is_pressed()
	update_text()

func OnlyMouseover_Toggle_pressed():
	only_show_mouseover = get_node("Menu/GridBox/Only-Mouseover Toggle").is_pressed()
	get_node("Label").set_hidden(only_show_mouseover)
	get_node("Timer Icon").set_hidden(not only_show_mouseover)

func mouse_enter():
	if only_show_mouseover:
		get_node("Label").show()
		get_node("Timer Icon").hide()

func mouse_exit():
	if only_show_mouseover:
		get_node("Label").hide()
		get_node("Timer Icon").show()
