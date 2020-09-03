
function NormalisePath( target_name, ext )
{
	var dot = target_name.Find(".");
	if ( dot == null )
		target_name = target_name + ext;
	else
		target_name = target_name.Slice( 0, dot ) + ext;

	target_name = target_name.ToUpper();
	return target_name;
}

function main( _args )
{
	if ( _args.Length() < 2 )
	{
		println( "Object Linker. Error: No Input File(s)" );
		return;
	}

	var target_name;
	var objects = [];
	var output_latch = false;
	var target_auto = true;

	// Read source files
	for ( var i = 1; i < _args.Length(); ++i )
	{
		var source_path = _args[ i ];

		if ( output_latch )
		{
			target_name = NormalisePath( source_path, ".GCX" );
			output_latch = false;
			target_auto = false;
		}
		else if ( source_path == "-o" )
		{
			output_latch = true;
			continue;
		}
		else
		{
			// Input file
			source_path = NormalisePath( source_path, ".OBJ" );

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

			if ( target_auto )
			{
				// Automatically set a default target name
				target_name = NormalisePath( source_path, ".GCX" );
			}
		}
	}

	print( "LINKING: " + target_name );

	// Link
	var result = GCBuild.Link( objects );

	if ( "error" in result )
	{
		print( "\n" + result.error );
	}
	else if ( "output" in result )
	{
		var out = GCFile.OpenWrite( target_name );

		if ( out <= 0 )
		{
			println( "\nError Writing " + target_name );
		}
		else
		{
			GCFile.WriteBuffer( out, result.output );
			GCFile.Close( result.output );
			putchar('\n');
		}
	}
	else
	{
		println( " FAILED" );
	}
}