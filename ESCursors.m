//
//  NSBezierPath+Cursors.m
//  Symmetries
//
//  Created by  Sven on 12.07.08.
//  Copyright 2008 earthlingsoft. All rights reserved.
//

#import "ESCursors.h"

#define ARROWSIZE 0.525
#define LINETHICKNESS 0.18


@implementation ESCursors

#pragma mark CURVED CURSORS 


+ (NSBezierPath *) curvedCursorBezierPathWithRightArrow:(BOOL) rightArrow upArrow:(BOOL) upArrow leftArrow:(BOOL) leftArrow downArrow: (BOOL) downArrow forAngle: (CGFloat) angle {
	const CGFloat handleFraction = 1.0 / 8.0;
	const CGFloat phi = pi / 20.0;
	NSAffineTransform * rotate = [NSAffineTransform transform];
	[rotate rotateByRadians:-phi];
	NSAffineTransform * rotate2 = [NSAffineTransform transform];
	[rotate2 rotateByRadians:-2.0 * phi];
	NSPoint pt;
	
	// left / right end points
	const NSPoint p1 = NSMakePoint(1.0, - sin(phi));
	const NSPoint p20 = NSMakePoint(-p1.x, p1.y);
	
	// left / right arrow top corner
	pt = [rotate transformPoint: NSMakePoint(-ARROWSIZE, ARROWSIZE)];
	const NSPoint p2 = NSMakePoint(p1.x + pt.x, p1.y + pt.y);
	const NSPoint p19 = NSMakePoint(-p2.x, p2.y);
	const NSPoint p38 = NSMakePoint(p1.x - pt.y, p1.y + pt.x);
	const NSPoint p21 = NSMakePoint(-p38.x, p38.y);
	
	// left/ right arrow bottom corner
	pt = [rotate transformPoint: NSMakePoint(0.0,  -(ARROWSIZE - LINETHICKNESS))];
	const NSPoint p3 = NSMakePoint(p2.x +  pt.x, p2.y + pt.y);
	const NSPoint p18 = NSMakePoint(-p3.x, p3.y);
	const NSPoint p37 = NSMakePoint(p38.x - pt.x, p38.y - pt.y);
	const NSPoint p22 = NSMakePoint(-p37.x, p37.y);
	
	// start handles for Bezier path
	pt = [rotate2 transformPoint: NSMakePoint(-handleFraction, 0.0)];
	const NSPoint p4 = NSMakePoint(p3.x + pt.x * 1.1, p3.y + pt.y * 1.1);
	const NSPoint p17 = NSMakePoint(-p4.x, p4.y);
	const NSPoint p36 = NSMakePoint(p37.x + pt.x * 0.9, p37.y + pt.y * 0.9);
	const NSPoint p23 = NSMakePoint(-p36.x, p36.y);	
	
	// off centre arrive point for Bezier path
	const CGFloat theta = asin(LINETHICKNESS);
	CGFloat correction = (1 - cos(theta));
	const NSPoint p7 = NSMakePoint(LINETHICKNESS, LINETHICKNESS - correction);
	const NSPoint p14 = NSMakePoint(-LINETHICKNESS, p7.y);
	const NSPoint p33 = NSMakePoint(LINETHICKNESS, - LINETHICKNESS - correction);
	const NSPoint p26 = NSMakePoint(-LINETHICKNESS, p33.y);

	// off centre arrive handles for Bezier path
	correction = 0.0;
	const NSPoint p5 = NSMakePoint(p7.x + 0.9 * handleFraction, p7.y - correction);
	const NSPoint p16 = NSMakePoint(- p5.x, p5.y);
	const NSPoint p35 = NSMakePoint(p33.x + 0.81 * handleFraction, p33.y - correction);
	const NSPoint p24 = NSMakePoint(-p35.x, p35.y);
	
	// central points and handles for Bezier path
	const NSPoint p8 = NSMakePoint(0.0, LINETHICKNESS);
	const NSPoint p27 = NSMakePoint(0.0, -LINETHICKNESS);
	const NSPoint p6 = NSMakePoint(handleFraction, LINETHICKNESS);
	const NSPoint p15 = NSMakePoint(-handleFraction, LINETHICKNESS);
	const NSPoint p34 = NSMakePoint(handleFraction, LINETHICKNESS);
	const NSPoint p25 = NSMakePoint(-handleFraction, LINETHICKNESS);
	
	// up arrow 
	NSPoint upArrowPoints [6];
	upArrowPoints[0] = NSMakePoint(LINETHICKNESS, 1.0 - ARROWSIZE);
	upArrowPoints[1] = NSMakePoint(ARROWSIZE, 1.0 - ARROWSIZE);
	upArrowPoints[2] = NSMakePoint(0.0, 1.0);
	upArrowPoints[3] = NSMakePoint(- ARROWSIZE, 1.0 - ARROWSIZE);
	upArrowPoints[4] = NSMakePoint(-LINETHICKNESS, 1.0 - ARROWSIZE);
	upArrowPoints[5] = p14;
	
	// down arrow
	NSPoint downArrowPoints [6];
	downArrowPoints[0] = NSMakePoint(-LINETHICKNESS, -1.0 + ARROWSIZE);
	downArrowPoints[1] = NSMakePoint(-ARROWSIZE, -1.0 + ARROWSIZE);
	downArrowPoints[2] = NSMakePoint(0.0, -1.0);
	downArrowPoints[3] = NSMakePoint(ARROWSIZE, -1.0 + ARROWSIZE);
	downArrowPoints[4] = NSMakePoint(LINETHICKNESS, -1.0 + ARROWSIZE);
	downArrowPoints[5] = p33;
	
	// now draw the paths
	NSBezierPath * bP = [NSBezierPath bezierPath];
	
	if (rightArrow) {
		[bP moveToPoint:p1];
		[bP lineToPoint:p2];
		[bP lineToPoint:p3];
		if (upArrow || !leftArrow) {
			// we are not drawing the long curve
			[bP curveToPoint:p7 controlPoint1:p4 controlPoint2:p5];
		}
		else {
			// we are going all the way to the left
			[bP curveToPoint:p8 controlPoint1:p4 controlPoint2:p6];
			[bP curveToPoint:p18 controlPoint1:p15 controlPoint2:p17];
		}
	}
	else {
		// there is no right arrow, begin at p7
		[bP moveToPoint:p7];
	}
	
	if (upArrow) {
		// we are at p7 now, draw the arrow
		[bP appendBezierPathWithPoints:upArrowPoints count:6];
	}
	else if (!upArrow && (!rightArrow || ! leftArrow) && !(rightArrow && leftArrow)) {
		// just move on in a straight line
		[bP lineToPoint:p14];
	}
	// we already covered the !upArrow && leftArrow situation above
	
	
	if (leftArrow) {
		if (upArrow || (!upArrow && !rightArrow)) {
			// we are at p14 and draw line to the the left arrow
			[bP curveToPoint:p18 controlPoint1:p16 controlPoint2:p17];
		}
		
		// We're at p18 now and draw the arrow tip itself
		[bP lineToPoint:p19];
		[bP lineToPoint:p20];
		[bP lineToPoint:p21];
		[bP lineToPoint:p22];

		if (downArrow || !rightArrow) {
			// we need to go to p26
			[bP curveToPoint:p26 controlPoint1:p23 controlPoint2:p24];
		}
		else {
			// we need to stroke all the way to the right arrow
			[bP curveToPoint:p27 controlPoint1:p23 controlPoint2:p25];
			[bP curveToPoint:p37 controlPoint1:p34 controlPoint2:p36];
		}
	
	}


	if (downArrow) {
		// we are at p26 (if leftArrow) or p14 (if !leftArrow) now, insert the arrow
		[bP appendBezierPathWithPoints:downArrowPoints count:6];
	}
	else {
		if (leftArrow) {
			if (!rightArrow) {
				// we are at p26, move to p33
				[bP lineToPoint:p33];
			}
		}
		else {
			// we are at p14, stroke to p33
			[bP lineToPoint:p26];
			[bP lineToPoint:p33];
		}
	}
	
	if (rightArrow) {
		if (! (leftArrow && !downArrow)) {
			// we are at p33, curve to p37
			[bP curveToPoint:p37 controlPoint1:p35 controlPoint2:p36];
		}
		// finishing stroke
		[bP lineToPoint:p38];
	}
	// if !rightArrow we started at p7
	
	// close path to get the missing stroke
	[bP closePath];
	
	return bP;
	}
	
	
	
+ (NSCursor *) curvedCursorWithRightArrow:(BOOL) rightArrow upArrow:(BOOL) upArrow leftArrow:(BOOL) leftArrow downArrow: (BOOL) downArrow forAngle: (CGFloat) angle size: (CGFloat) size {
	NSBezierPath * bP = [ESCursors curvedCursorBezierPathWithRightArrow:rightArrow upArrow:upArrow leftArrow:leftArrow downArrow:downArrow forAngle: angle];
	
	return [ESCursors cursorForBezierPath:bP withRotation: angle andSize: size];		
}


+ (NSCursor *) curvedCursorWithRightArrow:(BOOL) rightArrow upArrow:(BOOL) upArrow leftArrow:(BOOL) leftArrow downArrow: (BOOL) downArrow forAngle: (CGFloat) angle size: (CGFloat) size underlay:(NSImage*) underlay {
	NSBezierPath * bP = [ESCursors curvedCursorBezierPathWithRightArrow:rightArrow upArrow:upArrow leftArrow:leftArrow downArrow:downArrow forAngle: angle];
	
	return [ESCursors cursorForBezierPath:bP withRotation: angle size: size andUnderlay: underlay];		
}




#pragma mark CROSSED CURSORS

+ (NSBezierPath *) crossCursorBezierPathForAngle: (CGFloat) angle {
	NSPoint pointArray[6];
	pointArray[0] = NSMakePoint(1.0 - ARROWSIZE, ARROWSIZE);
	pointArray[1] = NSMakePoint(1.0 - ARROWSIZE, LINETHICKNESS);
	pointArray[2] = NSMakePoint(LINETHICKNESS, LINETHICKNESS);
	pointArray[3] = NSMakePoint(LINETHICKNESS, 1.0 - ARROWSIZE);
	pointArray[4] = NSMakePoint(ARROWSIZE, 1.0 - ARROWSIZE);
	pointArray[5] = NSMakePoint(0.0, 1.0);
	
	NSBezierPath * bP = [NSBezierPath bezierPath];
	[bP moveToPoint:NSMakePoint(1.0, 0.0)];
	
	NSAffineTransform * aT = [NSAffineTransform transform];
	[aT rotateByDegrees:-90.0];

	for (NSUInteger i=0; i<4; i++) {
		[bP appendBezierPathWithPoints:pointArray count:6];
		[bP transformUsingAffineTransform:aT];
	}
	
	[bP closePath];
	
	return bP;
}



+ (NSCursor *) crossCursorForAngle: (CGFloat) angle withSize: (CGFloat) size {
	NSBezierPath * bP = [ESCursors crossCursorBezierPathForAngle: angle];
	
	return [ESCursors cursorForBezierPath:bP withRotation: angle andSize: size];	
}




#pragma mark THREE PRONGED CURSORS


+ (NSBezierPath *) threeProngedCursorBezierPathForAngle: (CGFloat) angle {
	NSPoint pointArray[17];
	pointArray[0] = NSMakePoint(1.0 - ARROWSIZE, ARROWSIZE);
	pointArray[1] = NSMakePoint(1.0 - ARROWSIZE, LINETHICKNESS);
	pointArray[2] = NSMakePoint(LINETHICKNESS, LINETHICKNESS);
	pointArray[3] = NSMakePoint(LINETHICKNESS, 1.0 - ARROWSIZE);
	pointArray[4] = NSMakePoint(ARROWSIZE, 1.0 - ARROWSIZE);
	pointArray[5] = NSMakePoint(0.0, 1.0);
	pointArray[6] = NSMakePoint(- ARROWSIZE, 1.0 - ARROWSIZE);
	pointArray[7] = NSMakePoint(- LINETHICKNESS, 1.0 - ARROWSIZE);
	pointArray[8] = NSMakePoint(- LINETHICKNESS, LINETHICKNESS);
	pointArray[9] = NSMakePoint(-1.0 + ARROWSIZE, LINETHICKNESS);
	pointArray[10] = NSMakePoint(-1.0 + ARROWSIZE, ARROWSIZE);
	pointArray[11] = NSMakePoint(-1.0 , 0.0);
	pointArray[12] = NSMakePoint(- ARROWSIZE, - ARROWSIZE);
	pointArray[13] = NSMakePoint(- ARROWSIZE, - LINETHICKNESS);
	pointArray[14] = NSMakePoint(1.0 - ARROWSIZE, - LINETHICKNESS);
	pointArray[15] = NSMakePoint(1.0 - ARROWSIZE, - ARROWSIZE);
	pointArray[16] = NSMakePoint(1.0, 0.0);
	
	NSBezierPath * bP = [NSBezierPath bezierPath];
	
	[bP appendBezierPathWithPoints:pointArray count:17];
	[bP closePath];
	
	return bP;
}



+ (NSCursor *) threeProngedCursorForAngle: (CGFloat) angle withSize: (CGFloat) size {
	NSBezierPath * bP = [ESCursors threeProngedCursorBezierPathForAngle: angle];
	
	return [ESCursors cursorForBezierPath: bP withRotation: angle andSize: size];	
}




#pragma mark ANGLE CURSORS


+ (NSBezierPath *) angleCursorBezierPathForAngle: (CGFloat) angle {
	NSPoint pointArray[12];
	pointArray[0] = NSMakePoint(1.0 - ARROWSIZE, ARROWSIZE);
	pointArray[1] = NSMakePoint(1.0 - ARROWSIZE, LINETHICKNESS);
	pointArray[2] = NSMakePoint(LINETHICKNESS, LINETHICKNESS);
	pointArray[3] = NSMakePoint(LINETHICKNESS, 1.0 - ARROWSIZE);
	pointArray[4] = NSMakePoint(ARROWSIZE, 1.0 - ARROWSIZE);
	pointArray[5] = NSMakePoint(0.0, 1.0);
	pointArray[6] = NSMakePoint(- ARROWSIZE, 1.0 - ARROWSIZE);
	pointArray[7] = NSMakePoint(- LINETHICKNESS, 1.0 - ARROWSIZE);
	pointArray[8] = NSMakePoint(- LINETHICKNESS, -LINETHICKNESS);
	pointArray[9] = NSMakePoint(1.0 - ARROWSIZE, - LINETHICKNESS);
	pointArray[10] = NSMakePoint(1.0 - ARROWSIZE, - ARROWSIZE);
	pointArray[11] = NSMakePoint(1.0, 0.0);
	
	NSBezierPath * bP = [NSBezierPath bezierPath];
	
	[bP appendBezierPathWithPoints:pointArray count:12];
	[bP closePath];
	
	return bP;
}



+ (NSCursor *) angleCursorForAngle: (CGFloat) angle withSize: (CGFloat) size {
	NSBezierPath * bP = [ESCursors angleCursorBezierPathForAngle: angle];
	
	return [ESCursors cursorForBezierPath: bP withRotation: angle andSize: size];	
}



#pragma mark STRAIGHT CURSORS

+ (NSBezierPath *) straightCursorBezierPathForAngle: (CGFloat) angle {
	NSPoint pointArray[5];
	pointArray[0] = NSMakePoint(1.0 - ARROWSIZE, ARROWSIZE);
	pointArray[1] = NSMakePoint(1.0 - ARROWSIZE, LINETHICKNESS);
	pointArray[2] = NSMakePoint(-1.0 + ARROWSIZE, LINETHICKNESS);
	pointArray[3] = NSMakePoint(-1.0 + ARROWSIZE, ARROWSIZE);
	pointArray[4] = NSMakePoint(-1.0, 0.0);
	
	NSBezierPath * bP = [NSBezierPath bezierPath];
	[bP moveToPoint:NSMakePoint(1.0, 0.0)];
	
	NSAffineTransform * aT = [NSAffineTransform transform];
	[aT rotateByDegrees:180.0];
	
	[bP appendBezierPathWithPoints:pointArray count:5];
	[bP transformUsingAffineTransform:aT];
	[bP appendBezierPathWithPoints:pointArray count:5];
	[bP closePath];
	
	return bP;
}



+ (NSCursor *) straightCursorForAngle: (CGFloat) angle withSize: (CGFloat) size {
	NSBezierPath * bP = [ESCursors straightCursorBezierPathForAngle: angle];
	
	return [ESCursors cursorForBezierPath: bP withRotation: angle andSize: size];	
}




+ (NSBezierPath *) halfStraightCursorBezierPathForAngle: (CGFloat) angle {
	NSPoint pointArray[10];
	pointArray[0] = NSMakePoint(1.0 - ARROWSIZE, ARROWSIZE);
	pointArray[1] = NSMakePoint(1.0 - ARROWSIZE, LINETHICKNESS);
	pointArray[2] = NSMakePoint(-0.2 * LINETHICKNESS, LINETHICKNESS);
	pointArray[3] = NSMakePoint(-0.2 * LINETHICKNESS, 1.0);
	pointArray[4] = NSMakePoint(- 2.5 * LINETHICKNESS, 1.0);
	pointArray[5] = NSMakePoint(- 2.5 * LINETHICKNESS, -1.0);
	pointArray[6] = NSMakePoint(-0.2 * LINETHICKNESS, - 1.0);
	pointArray[7] = NSMakePoint(-0.2 * LINETHICKNESS, - LINETHICKNESS);
	pointArray[8] = NSMakePoint(1.0 - ARROWSIZE, - LINETHICKNESS);
	pointArray[9] = NSMakePoint(1.0 - ARROWSIZE, - ARROWSIZE);
	
	NSBezierPath * bP = [NSBezierPath bezierPath];
	[bP moveToPoint:NSMakePoint(1.0, 0.0)];
	
	[bP appendBezierPathWithPoints:pointArray count:10];
	[bP closePath];
	
	return bP;
}



+ (NSCursor *) halfStraightCursorForAngle: (CGFloat) angle withSize: (CGFloat) size {
	NSBezierPath * bP = [ESCursors halfStraightCursorBezierPathForAngle: angle];
	
	return [ESCursors cursorForBezierPath: bP withRotation: angle andSize: size];	
}



#pragma mark HELPER METHODS

#define OUTLINEWIDTH 1.0

+ (NSCursor *) cursorForBezierPath: (NSBezierPath *) bP withRotation: (CGFloat) angle andSize: (CGFloat) size {
	return [ESCursors  cursorForBezierPath: bP withRotation: angle size: size andUnderlay:nil];
}


+ (NSCursor *) cursorForBezierPath: (NSBezierPath *) bP withRotation: (CGFloat) angle size: (CGFloat) size andUnderlay:(NSImage *) underlay {
	// NSLog(@"Redrawing cursor");
	const CGFloat s = size * sqrt(2.0);		

	NSAffineTransform * aT = [NSAffineTransform transform];
	[aT rotateByRadians:angle];
	[aT scaleBy:size / 2.0 ];
	[bP transformUsingAffineTransform:aT];
	
	aT = [NSAffineTransform transform];
	[aT translateXBy: s/2.0 + 0.65 yBy: s/2.0 + 0.65];
	[bP transformUsingAffineTransform:aT];
	
	NSImage * image = [[NSImage alloc] initWithSize:NSMakeSize(s, s)];
	[image lockFocus];
	if (underlay) {
		[underlay compositeToPoint:NSMakePoint(s/2.0 - underlay.size.width / 2.0 + 0.65, s/2.0 - underlay.size.height/2.0 + 0.65) operation:NSCompositeCopy];
	}
	[[NSColor blackColor] set];
	[bP fill];
	[[NSColor whiteColor] set];
	bP.lineWidth = 1.0;
	[bP stroke];
	// [bP drawPointsAndHandles];
	[image unlockFocus];
	
	NSCursor * theCursor = [[NSCursor alloc] initWithImage:image hotSpot:NSMakePoint(s/2.0, s/2.0)];
	
	return theCursor;
}


@end
