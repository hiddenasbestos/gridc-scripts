
Copy raw binary file(s) into the active Game Link emulator memory.

=====================
How to Install Script
=====================

1. Drag the file "GLMEMW.GCX" onto the Grid Cartographer window
2. OK the on-screen prompt (or choose another file name)
3. Open the Grid Cartographer console window/viewport
4. Enter GLMEMW at the command prompt

=====================
Usage
=====================

GLMEMW [options] <file] [...]

   -?         Show usage.
   -a <addr>  Specify the target address.
   
   <file>     Binary file(s) to upload.
   

The target address can be specified in decimal (default) or as hex 
by using a '0x', '$' or '&' prefix.

