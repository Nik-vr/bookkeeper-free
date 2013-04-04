Copyright (c) 2009 Dmitry Boyarintsev
You're free to use these sources in anyway you find useful.

= Manual Docker =

There's been a lot of patches and wishes for Messages window to be docked 
at the source editor of Lazarus IDE. All patches were eventually rejected, 
because Messages window must be dockable by using Docking manager, that's 
not yet fully implemented for all widgetset. 

Keeping Messages window floating might be very annoying for some people, 
especially coming from Delphi. 


This IDE extension allows Messages window to dock to the source editor. 


== Installation ==

Download the extension sources. 
Copy the extensions source directory to Lazarus/Components directory. 
Start Lazarus IDE (if not started) 
Open installed packages manager Package->Configure installed packages... 
Select "manualdock 1.0" from "Available packages list" 
Press "Save and rebuild IDE". 
[edit]

== How-to Use ==

After Lazarus IDE is rebuilt with the extension, you should see 
an additional menu item at View menu, named "Dock Messages window". 

Selecting this menu item will dock/undock messages window from the source editor.