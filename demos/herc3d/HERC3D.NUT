
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

var NEAR_PLANE = 1.0;

class HERC_LINE
{
	function constructor( _x0, _y0, _x1, _y1, _set, _steep = false )
	{
		if ( Math.abs( _x0 - _x1 ) < Math.abs( _y0 - _y1 ) )
		{
			// start again - steep mode!
			constructor( _y0, _x0, _y1, _x1, _set, true );
			return;
		}

		// Make left to right.
		if ( _x0 > _x1 )
		{
			x0 = _x1;
			y0 = _y1;
			x1 = _x0;
			y1 = _y0;
		}
		else
		{
			x0 = _x0;
			y0 = _y0;
			x1 = _x1;
			y1 = _y1;
		}

		// Store
		steep = _steep;

		// Find deltas
		dx = x1 - x0;
		dy = y1 - y0;

		if ( dy < 0 )
		{
			ydir = -1;
		}
		else
		{
			ydir = 1;
		}

		// Bresenham constants
		derror2 = 2 * Math.abs( dy );
		error2 = 0;

		// Starting position
		x = x0;
		y = y0;

		//
		// GO!
		//

		if ( _set )
		{
			if ( steep )
			{
				do
				{
					_plot( y, x );
				}
				while( _step() );
			}
			else
			{
				do
				{
					_plot( x, y );
				}
				while( _step() );
			}
		}
		else // clear
		{
			if ( steep )
			{
				do
				{
					_clear( y, x );
				}
				while( _step() );
			}
			else
			{
				do
				{
					_clear( x, y );
				}
				while( _step() );
			}
		}
	}

	//--------------------------------------------------------------------------
	// Helpers
	//--------------------------------------------------------------------------

	function _plot( x, y )
	{
		if ( x >= 0 && y >= 0 && x < 720 && y < 348 )
		{
			var addr = (0xb0000) + ((y&3)<<13)+(y>>2)*90+(x>>3);
			GCConsole.Write8( addr, GCConsole.Read8( addr ) | ( 0x80 >> ( x & 7 ) ) );
		}
	}

	function _clear( x, y )
	{
		if ( x >= 0 && y >= 0 && x < 720 && y < 348 )
		{
			var addr = (0xb0000) + ((y&3)<<13)+(y>>2)*90+(x>>3);
			GCConsole.Write8( addr, GCConsole.Read8( addr ) & ~( 0x80 >> ( x & 7 ) ) );
		}
	}

	function _step()
	{
		var result = true;	// Assume we're on the line.

		if ( dx == 0 )
		{
			// Vertical
			++y;

			if ( y > y1 )
			{
				--y;
				result = false;
			}
		}
		else
		{
			// Horizontal
			++x;

			if ( x > x1 || x >= 720 )
			{
				--x;
				result = false;
			}
			else
			{
				error2 += derror2;
				if ( error2 > dx )
				{
					y += ydir;
					error2 -= dx * 2;
				}
			}
		}

		// Result
		return result;
	}

	//--------------------------------------------------------------------------
	// Implementation Data
	//--------------------------------------------------------------------------

	dx = 0;
	dy = 0;
	x0 = 0;
	y0 = 0;
	x1 = 0;
	y1 = 0;
	error2 = 0;
	derror2 = 0;
	ydir = 0;
	x = 0;
	y = 0;
	steep = false;
}

//====================================================

function MUL_VEC_TMAT( v, m )
{
	var r =
	[
		(m[ 0]*v[0])+(m[ 1]*v[1])+(m[ 2]*v[2])+(m[ 3]*v[3]),
		(m[ 4]*v[0])+(m[ 5]*v[1])+(m[ 6]*v[2])+(m[ 7]*v[3]),
		(m[ 8]*v[0])+(m[ 9]*v[1])+(m[10]*v[2])+(m[11]*v[3]),
		(m[12]*v[0])+(m[13]*v[1])+(m[14]*v[2])+(m[15]*v[3])
	];
	return r;
}

function MUL_VEC_MAT( v, m )
{
	var r =
	[
		(m[ 0]*v[0])+(m[ 4]*v[1])+(m[ 8]*v[2])+(m[12]*v[3]),
		(m[ 1]*v[0])+(m[ 5]*v[1])+(m[ 9]*v[2])+(m[13]*v[3]),
		(m[ 2]*v[0])+(m[ 6]*v[1])+(m[10]*v[2])+(m[14]*v[3]),
		(m[ 3]*v[0])+(m[ 7]*v[1])+(m[11]*v[2])+(m[15]*v[3])
	];
	return r;
}

function MUL_VEC3_MAT( v, m )
{
	var r =
	[
		(m[ 0]*v[0])+(m[ 4]*v[1])+(m[ 8]*v[2])+(m[12]),
		(m[ 1]*v[0])+(m[ 5]*v[1])+(m[ 9]*v[2])+(m[13]),
		(m[ 2]*v[0])+(m[ 6]*v[1])+(m[10]*v[2])+(m[14]),
		(m[ 3]*v[0])+(m[ 7]*v[1])+(m[11]*v[2])+(m[15])
	];
	return r;
}

function MUL_MAT_MAT( a, b )
{
	var r = [
		0.0, 0.0, 0.0, 0.0,
		0.0, 0.0, 0.0, 0.0,
		0.0, 0.0, 0.0, 0.0,
		0.0, 0.0, 0.0, 0.0
	];

	for ( var i = 0; i < 4; ++i ) // A's Row
	for ( var j = 0; j < 4; ++j ) // B's Column
	for ( var k = 0; k < 4; ++k ) // Iterator
	{
		r[ ( 4 * i ) + j ] += a[ ( 4 * i ) + k ] * b[ ( 4 * k ) + j ];
	}

	return r;
}

function line_clipper( a, b, mproj )
{
	// both points behind the near plane?
	if ( a[ 2 ] < NEAR_PLANE && b[ 2 ] < NEAR_PLANE )
	{
		return null;
	}

	var pa, pb;

	// both points in front of the near plane?
	if ( a[ 2 ] >= NEAR_PLANE && b[ 2 ] >= NEAR_PLANE )
	{
		pa = MUL_VEC3_MAT( a, mproj );
		pb = MUL_VEC3_MAT( b, mproj );
	}
	else
	{
		// -- CLIPPING REQUIRED

		var line_delta =
		[
			b[ 0 ] - a[ 0 ],
			b[ 1 ] - a[ 1 ],
			b[ 2 ] - a[ 2 ]
		];

		var line_length = Math.sqrt(
			line_delta[ 0 ] * line_delta[ 0 ] +
			line_delta[ 1 ] * line_delta[ 1 ] +
			line_delta[ 2 ] * line_delta[ 2 ] );

		var line_dir =
		[
			line_delta[ 0 ] / line_length,
			line_delta[ 1 ] / line_length,
			line_delta[ 2 ] / line_length,
		];

		var intersection_time = line_dir[ 2 ];
		if ( intersection_time == 0 )
			return null;

		intersection_time = -( a[ 2 ] - NEAR_PLANE ) / intersection_time;

		var c =
		[
			a[ 0 ] + intersection_time * line_dir[ 0 ],
			a[ 1 ] + intersection_time * line_dir[ 1 ],
			a[ 2 ] + intersection_time * line_dir[ 2 ],
			1.0
		];

		if ( a[ 2 ] < NEAR_PLANE )
		{
			pa = MUL_VEC3_MAT( b, mproj );
			pb = MUL_VEC3_MAT( c, mproj );
		}
		else
		{
			pa = MUL_VEC3_MAT( a, mproj );
			pb = MUL_VEC3_MAT( c, mproj );
		}
	}

	var out =
	[
		( pa[ 0 ] / pa[ 3 ] ),
		( pa[ 1 ] / pa[ 3 ] ),
		( pb[ 0 ] / pb[ 3 ] ),
		( pb[ 1 ] / pb[ 3 ] ),
	];

	return out;
}

function draw_clipped_line( a, b, mproj, e )
{
	var clip = line_clipper( a, b, mproj );

	// if the line is totally hidden, ignore it.
	if ( clip == null )
		return;

	// convert to viewport scale
	var vp =
	[
		( clip[ 0 ] * 360 + 360 ).ToInt(),
		( clip[ 1 ] * -174 + 174 ).ToInt(),
		( clip[ 2 ] * 360 + 360 ).ToInt(),
		( clip[ 3 ] * -174 + 174 ).ToInt()
	];

	// 2d off-screen rejection.
	if ( vp[0] < 0 && vp[2] < 0 )
		return;
	if ( vp[0] >= 720 && vp[2] >= 720 )
		return;
	if ( vp[1] < 0 && vp[3] < 0 )
		return;
	if ( vp[1] >= 348 && vp[3] >= 348 )
		return;

	HERC_LINE( vp[0], vp[1], vp[2], vp[3], e );
}

function draw_lines( vert_arr, index_arr, mproj, e )
{
	var lc = index_arr.Length();

	for ( var iline = 0; iline < lc; iline += 2 )
	{
		var va = index_arr[ iline ];
		var vb = index_arr[ iline + 1 ];

		draw_clipped_line(
			vert_arr[ va ],
			vert_arr[ vb ],
			mproj,
			e );
	}
}

//==============================================================================

function main( args )
{
	GCConsole.AutoYield( false );

	if ( GCConsole.Mode( 15 ) == false )
	{
		println( "Failed to set HERC graphics mode." );
		return;
	}

	var mproj =	[	1.2, 	0.0, 		0.0, 			0.0,
					0.0, 	2.0, 		0.0, 			0.0,
					0.0, 	0.0, 		1.0, 			1.0,
					0.0, 	0.0, 		-NEAR_PLANE,	0.0	];

	var mview = [	1, 0, 0, 0,
					0, 1, 0, 0,
					0, 0, 1, 0,
					0, 0, 0, 1	];

	var mworld =[	1, 0, 0, 0,
					0, 1, 0, 0,
					0, 0, 1, 0,
					0, 0, 0, 1	];

	var mcp = MUL_MAT_MAT( mproj, mview );

	var yaw = 0;
	var x = 0;
	var z = 5;

	var speed = 1.0;

	var run_forever = true;

	do
	{
		var cy = Math.cos( yaw * Math.DEGTORAD );
		var sy = Math.sin( yaw * Math.DEGTORAD );

		mworld[ 0 ] = cy;
		mworld[ 2 ] = -sy;
		mworld[ 8 ] = sy;
		mworld[10 ] = cy;

		mworld[ 12 ] = x;
		mworld[ 14 ] = z;

		var sz = 1.0; // model size

		var vert_arr =
		[
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ -sz, sz, -sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ sz, sz, -sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ sz, -sz, -sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ -sz, -sz, -sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ -sz, sz, sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ sz, sz, sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ sz, -sz, sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ -sz, -sz, sz ], mworld ), mview ),
			MUL_VEC3_MAT( MUL_VEC3_MAT( [ 0, sz, 0 ], mworld ), mview ),
		];

		var lines_pyramid =
		[
			2, 3, 6, 7, 2, 6, 3, 7, 2, 8, 3, 8, 6, 8, 7, 8
		];

		var lines_cube =
		[
			0, 1,	1, 2,	2, 3,	3, 0,
			0, 4,	1, 5,	2, 6,	3, 7,
			4, 5,	5, 6,	6, 7,	7, 4,
		];

		var obj = lines_cube;

		// draw object in white
		draw_lines( vert_arr, obj, mproj, 1 );

		GCKernel.Wait( 50 );

		// clear object by drawing it in black.
		draw_lines( vert_arr, obj, mproj, 0 );

		//
		// -- Handle Input

		var inp = GCConsole.PeekChar();

		if ( inp == GCKey.Esc )
			run_forever = false;
		if ( inp == GCKey.Left )
			x -= speed;
		if ( inp == GCKey.Right )
			x += speed;
		if ( inp == GCKey.Up )
			z += speed;
		if ( inp == GCKey.Down )
			z -= speed;

		yaw += 5;

	}
	while( run_forever );
}

