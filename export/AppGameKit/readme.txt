
=====================
Introduction
=====================

This is an example script to demonstrate exporting map data into a format
easily readable by AppGameKit 2.

The script requires version 4.5 of Grid Cartographer 4 Pro/Steam or later.


=====================
How to Install Script
=====================

1. Load Grid Cartographer.
2. Click the "G" tab at the top-left of the interface.
3. Choose the "Scripts" page
4. Click the "USER SCRIPTS FOLDER ..." button and a file explorer
	or Finder window will appear.
5. Copy the two files "export_AppGameKit.nut" and "export_AppGameKit.xml" from
	the 'Script' folder into the user scripts folder that opened.
6. Exit and restart Grid Cartographer.
7. Verify the script is installed by clicking the "File" menu > "Export" sub-menu.
8. A new option "AppGameKit Map" should be visible.


===============
Example Project
===============

The AppGameKit example ion the Project folder of this package loads a test map
and prints some basic information to the screen.

Feel free to edit the GCReadMap and GCReadTileMap functions and script to modify 
the file format to your needs.

The Data Export Reference can be used to decode the marker, terrain and edge
styles: https://docs.gridcartographer.com/ref/table/edge


=====================
License
=====================

Copyright 2018 David Walters

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
