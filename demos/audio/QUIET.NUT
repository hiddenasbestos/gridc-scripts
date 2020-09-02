
function sn_out( data )
{
	GCConsole.WriteCtrl( 0xC0, data );
}

function main( args )
{
	println( "Sssh!" );

	// mute
	sn_out( 0x9F );
	sn_out( 0xBF );
	sn_out( 0xDF );
	sn_out( 0xFF );
}

