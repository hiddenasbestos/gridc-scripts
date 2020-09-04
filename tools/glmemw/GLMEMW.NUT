
/*

MIT License

Copyright (c) 2020 David Walters

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

function usage()
{
	print( "Copy raw binary file(s) into the active Game Link emulator memory.\n\n" );
	print( "usage: GLMEMW [options] <file> [...]\n\n" );
	print( "   -?         Show this help.\n" );
	print( "   -a <addr>  Specify the target address.\n" );
	putchar('\n');
	print( "   <file>     Binary file(s) to upload.\n" );
}

function main( _args )
{
	if ( _args.Length() < 2 )
	{
		usage();
		return;
	}

	if ( GCGameLink.IsActive() == false )
	{
		println( "Game Link is not active." );
		return;
	}

	var objects = [];
	var addr_latch = false;
	var address = 0;

	// Read source files
	for ( var i = 1; i < _args.Length(); ++i )
	{
		var source_path = _args[ i ];

		if ( addr_latch )
		{
			address = source_path.ToInt();
			addr_latch = false;
		}
		else if ( source_path[ 0 ] == '-' )
		{
			if ( source_path == "-a" )
			{
				addr_latch = true;
				continue;
			}
			else if ( source_path == "-?" )
			{
				usage();
				return;
			}
			else
			{
				println( "Unknown switch " + source_path );
				return;
			}
		}
		else
		{
			// Input file
			source_path = source_path.ToUpper();

			var source_file = GCFile.OpenRead( source_path );

			if ( source_file <= 0 )
			{
				println( "File Not Found: " + source_path );
				return;
			}

			var source_length;
			source_length = GCFile.Length( source_file );

			var source_buffer = GCBuffer.Create();
			GCFile.ReadBuffer( source_file, source_length, source_buffer );

			// Add object record.
			objects.Add(
			{
				buffer = source_buffer,
				name = GCFile.Name( source_file )
			} );

			// done with handle.
			GCFile.Close( source_file );
		}
	}

	print( "Writing data to " + address.ToHexStr() + "h: " );

	var addressStart = address;

	foreach ( o in objects )
	{
		GCBuffer.Seek( o.buffer, 0 );

		while ( GCBuffer.EOF( o.buffer ) == GCOK )
		{
			var c = GCBuffer.Read8( o.buffer );
			GCGameLink.Write8( address, c );
			++address;
		}
	}

	println( "OK (" + ( address - addressStart ) + " bytes)" );
}

