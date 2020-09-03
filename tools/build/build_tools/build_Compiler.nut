
function main( _args )
{
	/*println( "-- started compiler" );
	GCConsole.PrintObj( _args );
	println( "-- end of compiler" );*/

	if ( _args.Length() < 2 )
	{
		println( "Script Compiler. Error: No Input File" );
		return;
	}

	var source_path = _args[ 1 ];
	var dot = source_path.Find(".");
	if ( dot == null )
		source_path = source_path + ".NUT";
	else
		source_path = source_path.Slice( 0, dot ) + ".NUT";
	source_path = source_path.ToUpper();

	var target_name;
	if ( _args.Length() > 2 )
	{
		target_name = _args[ 2 ];
	}

	var source_file = GCFile.OpenRead( source_path );

	if ( source_file <= 0 )
	{
		println( "File Not Found" );
	}
	else
	{
		var source_name = GCFile.Name( source_file );

		// Auto-generate target name?
		if ( target_name == null )
			target_name = source_name;
		var dot = target_name.Find(".");
		if ( dot == null )
			target_name = target_name + ".OBJ";
		else
			target_name = target_name.Slice( 0, dot ) + ".OBJ";
		target_name = target_name.ToUpper();

		var source_length;
		source_length = GCFile.Length( source_file );

		var source_buffer = GCBuffer.Create();
		GCFile.ReadBuffer( source_file, source_length, source_buffer );

		print( "COMPILING: " + source_name );

		// Compile
		var result = GCBuild.Compile( source_buffer, source_name );

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
				println( " -> " + GCFile.Name( out ) );
				GCFile.WriteBuffer( out, result.output );
				GCFile.Close( result.output );
			}
		}
		else
		{
			println( " FAILED" );
		}
	}
}