extends Button
tool

var save_filepath = "res://addons/Ross's Project Timer/time.sav"
var options_filepath = "res://addons/Ross's Project Timer/options.sav"

var t = 0
var manually_paused = false

# Options vars - names need to match up with keys names in save_options()
var pause_on_switch = true
var use_pause_anim = true
var show_seconds = true
var only_show_mouseover = false
var collapsible = false

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
	var s = t % 60
	var m = int(t/60) % 60
	var h = int(t/3600)
	var string = str(h) + ":" + str(m).pad_zeros(2)
	if show_seconds: string += ":" + str(s).pad_zeros(2)
	get_node("Label").set_text(string)

func load_time():
	var save = File.new()
	if not save.file_exists(save_filepath):
		save_time()
	save.open(save_filepath, File.READ)
	t = save.get_64()
	save.close()
	print("[Ross's Project Timer] Loading . . . Time: ", t)

func save_time():
	var save = File.new()
	save.open(save_filepath, File.WRITE)
	save.store_64(t)
	save.close()
	print("[Ross's Project Timer] Saving . . . Time: ", t)

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
	get_node("Menu/GridBox/GridContainer/Collapsible Toggle").set_pressed(collapsible)
	if only_show_mouseover and collapsible:
		collapse(true)
	
	save.close()

func save_options():
	var save = File.new()
	save.open(options_filepath, File.WRITE)
	var data = {"pause_on_switch"	 : pause_on_switch, 
				"use_pause_anim"	 : use_pause_anim,
				"show_seconds"		 : show_seconds,
				"only_show_mouseover": only_show_mouseover,
				"collapsible"		 : collapsible}
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

func Add_Button_pressed():
	var time = get_node("Menu/GridBox/Add Time Button/Time SpinBox").get_value()
	t += int(time) * 60
	update_text()

func Subtract_Button_pressed():
	var time = get_node("Menu/GridBox/Add Time Button/Time SpinBox").get_value()
	t -= int(time) * 60
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
	if collapsible:
		if not only_show_mouseover: collapse(false)
		elif not has_focus(): collapse(true)

func Collapsible_Toggle_pressed():
	collapsible = get_node("Menu/GridBox/GridContainer/Collapsible Toggle").is_pressed()
	if not collapsible: collapse(false)
	elif only_show_mouseover and not has_focus(): collapse(true)

func collapse(yes):
	if yes and not get_node("Collapse Anim").is_playing():
		get_node("Collapse Anim").play("collapse")
	else:
		get_node("Collapse Anim").stop()
		get_node("Collapse Anim").seek(0.0, true)

func mouse_enter():
	if only_show_mouseover:
		get_node("Label").show()
		get_node("Timer Icon").hide()
		if collapsible: collapse(false)

func mouse_exit():
	if only_show_mouseover:
		get_node("Label").hide()
		get_node("Timer Icon").show()
		if collapsible: collapse(true)
