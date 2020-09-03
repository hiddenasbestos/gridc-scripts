
// Project: GCTileMap 
// Created: 2018-07-16

/*

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

*/

// show all errors
SetErrorMode(2)

// Dependencies
#include "GCReadMap.agc"


//---------------------------------------
// TEST
//---------------------------------------

map as GCMap

result = GCReadMap( "testMap.agkmap", map )

print( "GCReadMap returned:" )
print( result )

if result

	// print some info about the map:

	print( "map.gridShape$:" )
	print( map.gridShape$ )
	print( "map.tiles.length:" )
	print( map.tiles.length )
	print( "map.tiles[3,2].marker.style:" )
	print( map.tiles[ 3 + 2 * map.width ].marker.style )
	
endif

tilemap as GCTileMap

result = GCReadTileMap( "testTileMap.agkmap", tilemap )

print( "GCReadTileMap returned:" )
print( result )

if result

	// print some info about the tilemap:

	print( "tilemap.tiles.length:" )
	print( tilemap.tiles.length )
	print( "tilemap.tiles[0,2]:" )
	t = tilemap.tiles[ 0 + 2 * tilemap.width ]
	print( "index =" )
	print( t && 0xFFFF  )
	print( "flip-h =" )
	print( ( t && 0x40000000 ) >> 30 )
	print( "flip-v =" )
	print( ( t && 0x80000000 ) >> 31 )
	print( "tilemap.tiles[1,0]:" )
	t = tilemap.tiles[ 1 + 0 * tilemap.width ]
	print( "index =" )
	print( t && 0xFFFF  )
	print( "flip-h =" )
	print( ( t && 0x40000000 ) >> 30 )
	print( "flip-v =" )
	print( ( t && 0x80000000 ) >> 31 )	
endif


` pause on exit.
SYNC()
REPEAT
UNTIL GETPOINTERPRESSED()=1

