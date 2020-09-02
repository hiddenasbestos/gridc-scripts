
function main( args )
{
	println( "'Ode to Joy' from Beethoven's \"Choral\" symphony #9." );
	println( "Press <ESC> to stop." );

	GCConsole.AutoYield( false );

	// 'Ode to Joy' from Beethoven's "Choral" symphony #9.

	var v1 = "EEFG GFED CCDE E. D8 D2";
	var v2 = "EEFG GFED CCDE D. C8 C2";
	var v3 = "DDEC DE8F8EC D L8EFL4 ED CD<G2>";

	GCSpeaker.Play( 0, "O2 V15 MS L4 T120" );
	GCSpeaker.Play( 0, v1 );
	GCSpeaker.Play( 0, v2 );
	GCSpeaker.Play( 0, v3 );
	GCSpeaker.Play( 0, v2 );

	for ( ; ; )
	{
		GCKernel.Wait( 0 );

		if ( GCSpeaker.IsPlaying( 0 ) == false )
			break;

		if ( GCConsole.PeekChar() == 27 )
			break;
	}

	GCSpeaker.Stop( 0 );
}

