
function main( args )
{
	// https://www.youtube.com/watch?v=fgsEfQ2bg6k
	// kvee
	// "Music is once again Mega Man"

	GCConsole.AutoYield( false );

	var BPM = "150";

	GCSpeaker.Play( 0, "V15 MS L16 O3 T" + BPM );
	GCSpeaker.Play( 1, "V10 MS L16 O2 T" + BPM );
	GCSpeaker.Play( 2, "V15 L2 O1 T" + BPM );

	var P11 = "EDEF<A>DEF";
	var P12 = "AAADFFFA";

	GCSpeaker.Play( 0, P11 + P11 + P11 + P11 );
	GCSpeaker.Play( 1, P12 + P12 + P12 + P12 );
	GCSpeaker.Play( 2, "DC#C<B>" );

	GCSpeaker.Play( 0, P11 + P11 + P11 + P11 );
	GCSpeaker.Play( 1, P12 + P12 + P12 + P12 );
	GCSpeaker.Play( 2, "DC#C<B>" );

	var P21 = "	A	G	A	A#	D	G	A	A#	";
	var P22 = "	D	D	D	G	A#	A#	A#	D	";

	GCSpeaker.Play( 0, P21 + P21 + P21 + P21 );
	GCSpeaker.Play( 1, P22 + P22 + P22 + P22 );
	GCSpeaker.Play( 2, "	G	F#	F	E	" );

	GCSpeaker.Play( 0, P21 + P21 + P21 + P21 );
	GCSpeaker.Play( 1, P22 + P22 + P22 + P22 );
	GCSpeaker.Play( 2, "	G	F#	F	E" );

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

