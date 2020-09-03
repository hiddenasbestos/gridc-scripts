
//
// AppGameKit Map Export
//
// Exports the current floor as a binary file suitable for AppGameKit parsing.
//
// Version 1.1
//

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


function write_output_row( buffer, bound, y )
{
	var out = GCBuffer.Write8;
	var out_int = GCBuffer.Write32;
	var out_bool = GCBuffer.WriteBool;

	// For each column
	for ( var x = bound.min_x; x <= bound.max_x; ++x )
	{
		// Select the tile
		GCTile.Select( x, y );

		// Get it
		var tile = GCTile.Get();

		out_bool( buffer, tile.Visible );

		// ... marker
		out( buffer, tile.Marker.Type );
		out_int( buffer, ( "Custom" in tile.Marker ) ? tile.Marker.Custom : 0 );
		out( buffer, tile.Marker.Color );
		out_bool( buffer, tile.Marker.Switch );

		// ... terrain
		out( buffer, tile.Terrain.Type );
		out_int( buffer, ( "Custom" in tile.Terrain ) ? tile.Terrain.Custom : 0 );
		out( buffer, tile.Terrain.Color );

		// ... edge-r
		out( buffer, tile.EdgeR.Type );
		out( buffer, tile.EdgeR.Color );
		out_bool( buffer, tile.EdgeR.Switch );

		// ... edge-i
		if ( "EdgeI" in tile )
		{
			out( buffer, tile.EdgeI.Type );
			out( buffer, tile.EdgeI.Color );
			out_bool( buffer, tile.EdgeI.Switch );
		}

		// ... edge-b
		out( buffer, tile.EdgeB.Type );
		out( buffer, tile.EdgeB.Color );
		out_bool( buffer, tile.EdgeB.Switch );

		// ... FX
		out_bool( buffer, tile.FX.Dark );
		out_bool( buffer, tile.FX.R );
		out_bool( buffer, tile.FX.G );
		out_bool( buffer, tile.FX.B );

		// ... misc
		out_bool( buffer, tile.Ceiling );
		out_bool( buffer, tile.Print );
	}
}

function write_output_row_tilemap( buffer, bound, y )
{
	// For each column
	for ( var x = bound.min_x; x <= bound.max_x; ++x )
	{
		// Select the tile
		GCTile.Select( x, y );

		// Get it
		var tile = GCTile.Get();

		var index;

		if ( tile.Index == null )
		{
			GCBuffer.Write32( buffer, -1 );
		}
		else
		{
			index = tile.Index & 0xFFFF;

			if ( tile.FlipH )
				index = index | ( 1 << 30 );

			if ( tile.FlipV )
				index = index | ( 1 << 31 );

			GCBuffer.Write32( buffer, index );
		}
	}
}

function create_output( buffer, bound, origin )
{
	// Write header
	GCBuffer.WriteString( buffer, "AGKmap" );

	// Write version
	GCBuffer.Write8( buffer, 1 );

	var shape = GCRegion.Shape();
	var is_tilemap = ( shape == "tilemap_sq" );

	// Grid Shape
	GCBuffer.WriteString( buffer, shape );

	// Write map dimensions
	var width = bound.max_x - bound.min_x + 1;
	var height = bound.max_y - bound.min_y + 1;

	GCBuffer.Write32( buffer, bound.min_x );
	GCBuffer.Write32( buffer, bound.min_y );

	GCBuffer.Write32( buffer, width );
	GCBuffer.Write32( buffer, height );

	// Prepare some storage for the tiles (optimisation)
	GCBuffer.Prepare( buffer, width * height * 30 );

	// Iterate over the bounding box. Max values are inclusive so need <=

	if ( is_tilemap )
	{
		// Bottom-Left Origin?
		if ( origin == "bl" )
		{
			// Bottom-Left. Iterate each row, in reverse
			for ( var y = bound.max_y; y >= bound.min_y; --y )
			{
				write_output_row_tilemap( buffer, bound, y );

				// .. update progress bar
				var pct = 100 - ( y * 100 / height );
				GCStatus.Progress( pct );
			}
		}
		else
		{
			// Top-Left. Iterate each row
			for ( var y = bound.min_y; y <= bound.max_y; ++y )
			{
				write_output_row_tilemap( buffer, bound, y );

				// .. update progress bar
				var pct = ( y * 100 / height );
				GCStatus.Progress( pct );
			}
		}
	}
	else
	{
		// Bottom-Left Origin?
		if ( origin == "bl" )
		{
			// Bottom-Left. Iterate each row, in reverse
			for ( var y = bound.max_y; y >= bound.min_y; --y )
			{
				write_output_row( buffer, bound, y );

				// .. update progress bar
				var pct = 100 - ( y * 100 / height );
				GCStatus.Progress( pct );
			}
		}
		else
		{
			// Top-Left. Iterate each row
			for ( var y = bound.min_y; y <= bound.max_y; ++y )
			{
				write_output_row( buffer, bound, y );

				// .. update progress bar
				var pct = ( y * 100 / height );
				GCStatus.Progress( pct );
			}
		}
	}

	GCStatus.Progress( 100 );
}

function export_buffer( buffer )
{
	// Export
	var result;
	result = GCExport.BufferAs( buffer,
								GCLocale( "FILE_SELECT_TITLE" ),
								null,
								"agkmap",
								GCLocale( "FILE_SELECT_DESC" ) );

	// Error?
	switch ( result )
	{

	case GCOK:
		GCStatus.Message( GCLocale( "ERROR_OK" ) );
		GCUI.MessageBox( GCLocale( "ERROR_OK" ),
						 GCMB_OK | GCMB_INFO );
		break;

	case GCERR_ABORT:
		GCStatus.Message( GCLocale( "ERROR_CANCEL" ) );
		break;

	case GCERR_ACCESS:
		GCStatus.Message( GCLocale( "ERROR_FAIL" ) );
		GCUI.MessageBox( GCLocale( "ERROR_ACCESS" ),
						 GCMB_OK | GCMB_STOP );
		break;

	default:
		GCStatus.Message( GCLocale( "ERROR_FAIL" ) );
		GCUI.MessageBox( GCLocale( "ERROR_INTERNAL" ),
						 GCMB_OK | GCMB_STOP );
		break;

	}
}

function main()
{
	// Get the origin
	var origin = GCRegion.Origin();

	// Error?
	if ( origin == null )
	{
		GCUI.MessageBox( GCLocale( "ERROR_INTERNAL" ),
						 GCMB_OK | GCMB_STOP );
		return;
	}

	// Begin blocking mode
	GCKernel.SetBlockingMode( true );

	// Get the bound
	var bound = GCFloor.FindBound();

	// Detect empty
	if ( bound == null )
	{
		GCUI.MessageBox( GCLocale( "ERROR_NONE" ), GCMB_OK | GCMB_INFO );
		return;
	}

	// Exporting
	GCStatus.Message( GCLocale( "STATUS_PROGRESS" ) );

//	var start_time = GCKernel.MSTime();

	GCStatus.Progress( 0 );

	// Create a buffer
	var buffer = GCBuffer.Create();

	// Create
	create_output( buffer, bound, origin );

	// End blocking mode
	GCKernel.SetBlockingMode( false );

//	var duration = GCKernel.MSTime() - start_time;
//	println( "Exported in " + duration + " ms" );

	// Export
	export_buffer( buffer );

	GCStatus.Progress( null );

	// Destroy buffer
	GCBuffer.Destroy( buffer );
}

