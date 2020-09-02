
var song =
[
	0x274,
	0,
	0x140,
	0,
	0x150,
	0,
	0x250,
	0,
];

var song2 =
[
	0,
	0,
	0,
	0x240,
	0,
	0x190,
	0,
	0x350,
];


function main( args )
{
	println( "Experimental composition by David Walters." );
	println( "Press <ESC> to stop." );

	GCConsole.AutoYield( false );

	var sl = song.Length();

	var cursor = 0;

	for ( var iframe = 0; iframe < 1000; ++iframe )
	{
		GCKernel.Wait(0);

		if ( iframe % 10 == 0 )
		{
			var s = song[ cursor % sl ];
			var s2 = song2[ cursor % sl ];

//			println( "0:" + s.ToHexStr() + "\t1:" + s2.ToHexStr() );

			if ( s == 0 )
			{
				GCConsole.WriteCtrl( 0xC0, 0x97 );
			}
			else
			{
				GCConsole.WriteCtrl( 0xC0, 0x80 | ( s & 0xF ) );
				GCConsole.WriteCtrl( 0xC0, ( s >> 4 ) & 0x3F );
				GCConsole.WriteCtrl( 0xC0, 0x90 );
			}

			if ( s2 == 0 )
			{
				GCConsole.WriteCtrl( 0xC0, 0xB7 );
			}
			else
			{
				GCConsole.WriteCtrl( 0xC0, 0xA0 | ( s2 & 0xF ) );
				GCConsole.WriteCtrl( 0xC0, ( s2 >> 4 ) & 0x3F );
				GCConsole.WriteCtrl( 0xC0, 0xB0 );
			}

			++cursor;

			if ( GCConsole.PeekChar() == 27 )
				break;
		}
	}

	GCConsole.WriteCtrl( 0xC0, 0x9F );
	GCConsole.WriteCtrl( 0xC0, 0xBF );
}

