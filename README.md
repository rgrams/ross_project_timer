# Ross's Project Timer
_A simple, unobtrusive, Godot engine editor plugin for tracking the time spent on a project._

_v 1.1.0 Readme_

![Screenshot](http://i.imgur.com/14cu5Cd.png)

_Screenshot of plugin widget with dropdown menu open_

[Click here for a full screen screenshot.](http://i.imgur.com/kwhBoeh.png) 

##How to use this plugin

1. Place the 'addons' folder in your project's root folder. 
(If you've downloaded this from the Asset Library it should happen automatically)

2. In Project Settings, in the Plugins tab, on the left side, click the dropdown menu for this plugin and set it to "Active". 

The plugin will create a button in the editor's top toolbar, on the left side, next to the colorful sound volume bar. It will
immediately start counting up time every second. 

By default the timer will automatically pause if you switch to a different window, and automatically resume when you switch back. You can toggle this on and off in the menu (see below). Your elapsed time is saved when you close the editor or disable the plugin, and loaded when you open the project again or re-enable the plugin.


##Menu

You can click on the plugin button and it will open a menu with a few different options:

- Pause (& Resume when paused): Pauses and resumes the timer. 

- Adjust Time - Use the buttons to add and subtract the amount of time selected in the input box from the elapsed time. 

- Reset Time: Resets the elapsed time to zero. Pops up a confirm dialog so you don't do it by mistake. 

- Pause on window switch: Toggle off to make the timer keep counting up when the editor window is not in focus. 

- Use pause animation: Toggle the fading animation for the timer text/icon. Turning this off can save a tiny bit of CPU time. 

- Show seconds: Toggle the display of seconds. 

- Only show on mouseover: If on, the widget will only display the time when your mouse is hovering on it. The rest of the time it will be replaced by a static icon. 

  - Collapse on mouse exit: Only applicable when the above option is checked. Collapses the widget to a small square button when your mouse is not on it. It expands to show the time when you mouse over it again. 

- Close Menu: closes the menu. (Or you can press escape or click on something else.)


##Other Features

You can right-click on the plugin button to quickly pause and resume. 


##Bugs / Feedback

Currently there is one error that I know about. If you deactivate the plugin it gives this error message:

     ERROR: set_persisting: Condition ' !props.has(p_name) ' is true.
          At: core/globals.cpp:100

However, every plugin I've tried, even the official ones, give this error message. It doesn't actually seem to cause any problems. If you know anything about this error, let me know. 

If you find any other bugs or have some feedback about things you would like to see changed or added, make an issue here on github, or you can contact me directly through my website: http://rossgrams.com/ Feature requests are welcome! (though I'm not going to do anything huge and crazy with this.)