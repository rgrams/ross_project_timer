# Ross's Project Timer
_v 0.1.0 Readme_

##How to use this plugin

1) Place the 'addons' folder in your project's root folder. 
(If you've downloaded this from the Asset Library it should happen automatically)

2) In Project Settings, go to the Plugins tab, then on the left side click the dropdown menu for this plugin and set it to "Active". 

The plugin will create a button in the editor's top toolbar, on the left side next to the colorful sound volume bar. It will
immediately start counting up time every second. 

If you switch to a different window it will automatically stop, and automatically resume when you switch back. It only counts
time when the editor window is in focus. It also saves the elapsed time when you close the editor or disable the plugin, and 
loads your time when you open the project again or re-enable the plugin. It keeps a save file in its addon folder. 


##Menu

You can click on the plugin button and it will open a menu with a few different options:

- Pause (& Resume when paused): Pauses and resumes the timer. 

- Reset Time: Resets the elapsed time to zero

- Add Time: Adds the amount of time selected in the input box to the elapsed time. 
            (Select a negative value to subtract time.)

- Close Menu: closes the menu. (Or you can press escape or click on something else.)


##Bugs / Feedback

Currently there is one error that I know about. If you deactivate the plugin it gives this error message:


     ERROR: set_persisting: Condition ' !props.has(p_name) ' is true.
          At: core/globals.cpp:100


I'm trying to figure out why, however it doesn't actually seem to cause any problems. If you know anything about this 
error, let me know. 

If you find any other bugs or have some feedback about things you would like to see changed or added, make an issue on github:

https://github.com/rgrams/ross_project_timer

Or you can contact me directly through my website: http://rossgrams.com/
