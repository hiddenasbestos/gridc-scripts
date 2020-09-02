
function sn_out( data )
{
	GCConsole.WriteCtrl( 0xC0, data );
}

function sn_freq( chan, freq )
{
	chan = 0x80 | ( chan << 5 );

	sn_out( chan | ( freq & 0xF ) );
	sn_out( ( freq >> 4 ) & 0x3F );
}

function main( args )
{
	println( "Noise linked to Tone 2 demo, by David Walters." );

	GCConsole.AutoYield( false );

	sn_out( 0xDF );
	sn_out( 0xF0 );

	sn_out( 0xE0 | 0b0111 );

//	sn_freq( 2, 254 );
//	GCKernel.Wait( 2000 );

	for ( var i = 0; i < 128; ++i )
	{
		sn_freq( 2, 192 - i );
		GCKernel.Wait( 0 );
	}

	// mute
	sn_out( 0x9F );
	sn_out( 0xBF );
	sn_out( 0xDF );
	sn_out( 0xFF );
}

