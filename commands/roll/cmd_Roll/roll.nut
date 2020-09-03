
//
// roll
//
// A simple dice roller.
//
// usage: roll [dice ...]
//
//  dice    A list of either 2d6 format or just the number of sides.
//
// e.g.
//
//  roll 2d6		- roll two six sided dice.
//	roll 20			- roll one twenty sided die.
//	roll 3d6 10		- roll three six sided dice and a ten sided die.
//	roll			- default: roll one six sided dice
//

function parse_args( args )
{
	var dice = [];

	// skip arg[0], the program name.
	for ( var i = 1; i < args.Length(); ++i )
	{
		var arg = args[ i ].ToLower();
		
		// Is this <n>d<f> format (e.g. 2d8)
		var a = arg.Split( "d" );
		
		if ( a.Length() == 2 )
		{
			var n = a[ 0 ].ToInt();
			var f = a[ 1 ].ToInt();
			
			if ( n > 0 && f >= 2 )
			{
				for ( var j = 0; j < n; ++j )
				{
					dice.Add( f );
				}
			}
		}
		else if ( a.Length() == 1 )
		{
			var f = a[ 0 ].ToInt();
			
			if ( f >= 2 )
			{
				dice.Add( f );
			}
		}
	}	
	
	return dice;
}

function main( _args )
{
	// Make an array of integers, one for each die
	// - the value is the number of sides
	var dice = parse_args( _args );
	
	// Default to 1D6.
	if ( dice.Length() == 0 ) {
		dice.Push( 6 );
	}
	
	var total = 0;
	
	print( "You rolled" );
	for ( var i = 0; i < dice.Length(); ++i )
	{
		var r = Math.rand( dice[ i ] ) + 1;
		
		if ( ( i > 0 ) && ( ( i + 1 ) < dice.Length() ) ) {
			print( ", " );
		} else if ( ( i > 0 ) && ( i + 1 == dice.Length() ) ) {
			print( " and " );
		} else {
			putchar( ' ' );
		}
		
		print( r.ToString() );
		
		total += r;
	}
	
	if ( dice.Length() > 1 )
	{
		print( ". Total is " + total );
	}
	
	putchar( '.' );
	putchar( '\n' );
}