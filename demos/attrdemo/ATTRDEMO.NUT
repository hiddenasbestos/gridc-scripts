
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

function attrdemo()
{
	var attr = GCConsole.Attrib;

	GCConsole.Clear();

	attr( 0x70 );
	print( "\n Character Attribute Demo " );
	attr( 7 );
	print( "\n\n" );

	for ( var y = 0; y < 16; ++y )
	{
		attr( 0 );

 		for ( var x = 0; x < 16; ++x )
		{
			if ( x > 0 ) {
				attr( 0 );
				putchar( ' ' );
			}
			attr( ( y << 4 ) | x );
			print( " " + y.ToHexStr().ToUpper() + x.ToHexStr().ToUpper() + " " );
		}

		putchar( '\n' );
	}

	attr( 7 );
	putchar( '\n' );

	attr( 0x34 );
	print( " Use 0x07 for: " );
	attr( 0x07 );
	print( " NORMAL TEXT " );
	attr( 0x7 );
	print( "\t\t" );

	attr( 0x34 );
	print( " Use 0x70 for: " );
	attr( 0x70 );
	print( " REVERSE TEXT " );
	attr( 0x7 );
	print( "\n" );

	attr( 0x34 );
	print( " Add 0x08 for: " );
	attr( 0x08 | 0x7 );
	print( " BRIGHT TEXT " );
	attr( 0x7 );
	print( "\t\t" );

	attr( 0x34 );
	print( " Add 0x80 for: " );
	attr( 0x80 | 0x7 );
	print( " BLINKING TEXT " );
	attr( 0x7 );
	print( "\n" );
}


function main( _args )
{
	attrdemo();
}