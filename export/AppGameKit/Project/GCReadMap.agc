
// Project: GCTileMap 
// Created: 2018-07-16

// Version 1.1

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


//---------------------------------------
// Type Declarations
//---------------------------------------

type GCMarker
	
	style as Integer // see marker table in data export manual
	sub as Integer
	color as Integer
	switch as Integer
	
endtype

type GCTerrain
	
	style as Integer // see terrain table in data export manual
	sub as Integer
	color as Integer
	
endtype

type GCEdge
	
	style as Integer // see edge table in data export manual
	color as Integer
	switch as Integer
	
endtype

type GCFX
	
	dark as Integer
	r as Integer
	g as Integer
	b as Integer
	
endtype

type GCTile
	
	visible as Integer
	
	marker as GCMarker
	terrain as GCTerrain
	
	edgeR as GCEdge
	edgeI as GCEdge // only used on hex maps
	edgeB as GCEdge
	
	fx as GCFX
	
	ceiling as Integer
	footprint as Integer
	
endtype

type GCMap
	
	gridShape$ as String	// one of "square", "hexh" or "hexv"
	
	originX as Integer		// map size
	originY as Integer
	width as Integer
	height as Integer
	
	tiles as GCTile[1]		// array is resized during read

endtype	

type GCTileMap
	
	originX as Integer		// map size
	originY as Integer
	width as Integer
	height as Integer
	
	tiles as Integer[1]		// array is resized during read

endtype	

//---------------------------------------
// Global Function
//---------------------------------------

function GCReadMap( path$ as String, map ref as GCMap )

	if GetFileExists( path$ ) = 0 then exitfunction 0

	// Open file.
	file = OpenToRead( path$ )
	if ( file = 0 ) then exitfunction 0
	
	// Validate header.
	file_id$ = ReadString( file )
	if ( file_id$ <> "AGKmap" ) then exitfunction 0
		
	// Validate version.
	file_ver = ReadByte( file )
	if ( file_ver <> 1 ) then exitfunction 0
	
	// Read grid shape
	map.gridShape$ = ReadString( file )
	if ( map.gridShape$ = "tilemap_sq" ) then exitfunction 0

	// Read dimensions of the map
	map.originX = ReadInteger( file )
	map.originY = ReadInteger( file )
	map.width = ReadInteger( file )
	if ( map.width <= 0 ) then exitfunction 0
	map.height = ReadInteger( file )
	if ( map.height <= 0 ) then exitfunction 0
	
	// Allocate tile map
	map.tiles.length = map.width * map.height
	
	isHex = map.gridShape$ <> "square"
	
	// Read tiles
	for y = 0 to map.height - 1
		
		for x = 0 to map.width - 1
			
			// workspace
			tile as GCTile
			
			//
			// - read tile
			
			tile.visible = ReadByte( file )
			
			// ... marker
			tile.marker.style = ReadByte( file )
			tile.marker.sub = ReadInteger( file )
			tile.marker.color = ReadByte( file )
			tile.marker.switch = ReadByte( file )
			
			// ... terrain
			tile.terrain.style = ReadByte( file )
			tile.terrain.sub = ReadInteger( file )
			tile.terrain.color = ReadByte( file )
			
			// ... edge-r
			tile.edgeR.style = ReadByte( file )
			tile.edgeR.color = ReadByte( file )
			tile.edgeR.switch = ReadByte( file )
			
			// ... edge-i
			if ( isHex )
				tile.edgeI.style = ReadByte( file )
				tile.edgeI.color = ReadByte( file )
				tile.edgeI.switch = ReadByte( file )
			endif

			// ... edge-b
			tile.edgeB.style = ReadByte( file )
			tile.edgeB.color = ReadByte( file )
			tile.edgeB.switch = ReadByte( file )
			
			// ... fx
			tile.fx.dark = ReadByte( file )
			tile.fx.r = ReadByte( file )
			tile.fx.g = ReadByte( file )
			tile.fx.b = ReadByte( file )
			
			// ... misc
			tile.ceiling = ReadByte( file )
			tile.footprint = ReadByte( file )

			// store in map
			map.tiles[ x + y * map.width ] = tile
			
		next x
		
	next y	

	CloseFile( file )

endfunction 1

function GCReadTileMap( path$ as String, map ref as GCTileMap )

	if GetFileExists( path$ ) = 0 then exitfunction 0

	// Open file.
	file = OpenToRead( path$ )
	if ( file = 0 ) then exitfunction 0
	
	// Validate header.
	file_id$ = ReadString( file )
	if ( file_id$ <> "AGKmap" ) then exitfunction 0
		
	// Validate version.
	file_ver = ReadByte( file )
	if ( file_ver <> 1 ) then exitfunction 0
	
	// Read grid shape
	gridShape$ = ReadString( file )
	if ( gridShape$ <> "tilemap_sq" ) then exitfunction 0

	// Read dimensions of the map
	map.originX = ReadInteger( file )
	map.originY = ReadInteger( file )
	map.width = ReadInteger( file )
	if ( map.width <= 0 ) then exitfunction 0
	map.height = ReadInteger( file )
	if ( map.height <= 0 ) then exitfunction 0
	
	// Allocate tile map
	map.tiles.length = map.width * map.height
	
	// Read tiles
	for y = 0 to map.height - 1
		
		for x = 0 to map.width - 1
			
			// store in map
			map.tiles[ x + y * map.width ] = ReadInteger( file )
			
		next x
		
	next y	

	CloseFile( file )

endfunction 1
