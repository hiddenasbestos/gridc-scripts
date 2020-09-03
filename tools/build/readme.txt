
=====================
Introduction
=====================

A script compiler and linker to create GCX applications.

The script requires version 4.5 of Grid Cartographer 4 Pro/Steam or later.


=====================
How to Install Script
=====================

1. Load Grid Cartographer.
2. Click the "G" tab at the top-left of the interface.
3. Choose the "Scripts" page
4. Click the "USER SCRIPTS FOLDER ..." button and a file explorer will open.
5. Copy the folder "build_tools" into the user scripts folder that opened.
6. Exit and restart Grid Cartographer.


=====================
Usage
=====================

usage: comp <source>[.nut] [<object>[.obj]]

 comp    Compile a plain-text script into an object file (.OBJ) for linking.


usage: link [<object>[.obj] ...] [-o <output>[.GCX]]

 link    Link multiple object files and output a GCX application.
 
