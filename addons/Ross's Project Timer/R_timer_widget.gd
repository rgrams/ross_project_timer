extends Button
tool

var save_filepath = "res://addons/Ross's Project Timer/time.sav"

var t = 0


func initialize():
	get_node("Label").set_text("Initializing...")
	get_node("Timer").connect("timeout", self, "timer_tick")
	connect("pressed", self, "button_pressed")
	get_node("Timer").start()
	load_time()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		get_node("Timer").stop()
		set_disabled(true)
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		get_node("Timer").start()
		set_disabled(false)

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

func _exit_tree():
	save_time()

func button_pressed():
	get_node("Menu").popup()
	get_node("Menu").set_global_pos(get_global_pos() - Vector2(0, -26))

func Reset_Button_pressed():
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
		get_node("Menu/GridBox/Pause-Resume Button").set_text("Resume")
		get_node("AnimationPlayer").play("paused")
	else:
		get_node("Timer").start()
		get_node("Menu/GridBox/Pause-Resume Button").set_text("Pause")
		get_node("AnimationPlayer").stop_all()
		get_node("Label").set_opacity(1.0)
