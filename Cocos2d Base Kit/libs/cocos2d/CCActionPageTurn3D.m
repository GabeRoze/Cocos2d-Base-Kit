/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2009 Sindesso Pty Ltd http://www.sindesso.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "CCActionPageTurn3D.h"

@implementation CCPageTurn3D

/*
 * Update each tick
 * Time is the percentage of the way through the duration
 */
-(void)update:(ccTime)time
{
	float tt = MAX( 0, time - 0.25f );
	float deltaAy = ( tt * tt * 500);
	float ay = -100 - deltaAy;

	float deltaTheta = - (float) M_PI_2 * sqrtf( time) ;
	float theta = /*0.01f*/ + (float) M_PI_2 +deltaTheta;

	float sinTheta = sinf(theta);
	float cosTheta = cosf(theta);

	for( int i = 0; i <=gridSize_.x; i++ )
	{
		for( int j = 0; j <= gridSize_.y; j++ )
		{
			// Get original vertex
			ccVertex3F	p = [self originalVertex:ccg(i,j)];

			float R = sqrtf(p.x*p.x + (p.y - ay) * (p.y - ay));
			float r = R * sinTheta;
			float alpha = asinf( p.x / R );
			float beta = alpha / sinTheta;
			float cosBeta = cosf( beta );

			// If beta > PI then we've wrapped around the cone
			// Reduce the radius to playerReachedBoundary these points interfering with others
			if( beta <= M_PI)
				p.x = ( r * sinf(beta));
			else
			{
				// Force X = 0 to playerReachedBoundary wrapped
				// points
				p.x = 0;
			}

			p.y = ( R + ay - ( r*(1 - cosBeta)*sinTheta));

			// We scale z here to avoid the animation being
			// too much bigger than the screen due to perspectve transform
			p.z = (r * ( 1 - cosBeta ) * cosTheta) / 7; // "100" didn't work for

			// Stop z coord from dropping beneath underlying page in a transition
			// issue #751
			if( p.z<0.5f )
				p.z = 0.5f;

			// Set new coords
			[self setVertex:ccg(i,j) vertex:p];
		}
	}
}
@end
