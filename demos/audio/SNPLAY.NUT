
include( "stdio/getline.nut" );

function main( args )
{
	println( "Musical Markup Demo. Enter markup to be processed on tone channel 0." );
	println( "See the documentation for GCSpeaker.Play for details." );
	println( "Press <CTRL+C> to exit.\n" );

	for ( ; ; )
	{
		print( "&>" );
		var input = getline( 256 );

		if ( input == null )
			break;

		GCSpeaker.Play( 0, input );
	}
}

