/*
 ESCursors.h
 
 v1 (2008-07-27)
 
 Created by  Sven on 24.05.08.
 Copyright 2008 earthlingsoft. All rights reserved.
 
 Available at
 http://earthlingsoft.net/code/ESCursors/
 More code at
 http://earthlingsoft.net/code/
 
 You may use this code in your own projects at your own risk.
 Please notify us of problems you discover. You are required 
 to give reasonable credit when using the code in your projects.
 
 ********************************************************************
 
 ESCursors provides a wide variety of arrow cursors. 
 
 In particular it provides rotated versions of cursors which NSCursor
 does not provide.
 
 Try out our Symmetries application, available at 
 http://earthlingsoft.net/Symmetries to see those cursors in action.
 
 For each cursor type there is a class method providing the cursor
 which calls a helper method that creates the Bézier path for the
 shape, draws it at the right size in black with a white border,
 rotated and scaled to the desired size and returns it as an NSCursor.
 
*/

#import <Cocoa/Cocoa.h>


@interface ESCursors : NSObject {
}


#pragma mark CURVED CURSORS

/*
	CURVED CURSORS
 
	A cross shaped cursor whose horizontal stroke is slightly curved to the bottom.
	The options specify which of the arrows should exist, not all of them should be NO.
 
	The arrow heads in these cursors overlap which gives the right look at small size but looks bad at huge sizes.
 
	The third variant with an 'underlay' lets you pass an image that is drawn beneath the cursor image. 
*/

+ (NSBezierPath *) curvedCursorBezierPathWithRightArrow:(BOOL) rightArrow
												upArrow:(BOOL) upArrow 
											  leftArrow:(BOOL) leftArrow 
											  downArrow: (BOOL) downArrow 
											   forAngle: (CGFloat) angle;

+ (NSCursor *) curvedCursorWithRightArrow:(BOOL) rightArrow 
								  upArrow:(BOOL) upArrow 
								leftArrow:(BOOL) leftArrow downArrow: (BOOL) downArrow 
								 forAngle: (CGFloat) angle 
									 size: (CGFloat) size;

+ (NSCursor *) curvedCursorWithRightArrow:(BOOL) rightArrow 
								  upArrow:(BOOL) upArrow 
								leftArrow:(BOOL) leftArrow 
								downArrow: (BOOL) downArrow 
								 forAngle: (CGFloat) angle 
									 size: (CGFloat) size 
								 underlay:(NSImage*) underlay;



#pragma mark STRAIGHT CURSORS

/*
	STRAIGHT CURSORS
	
	cross shaped
	threePronged (oriented like an upside-down T)
	right angle shaped (oriented like an L)
	straight line shaped (horizontal)
	semi-straight line shaped (horizontal, shorter and with a bar at the left end)
*/

+ (NSBezierPath *) crossCursorBezierPathForAngle: (CGFloat) angle;
+ (NSCursor *) crossCursorForAngle: (CGFloat) angle withSize: (CGFloat) size;

+ (NSBezierPath *) threeProngedCursorBezierPathForAngle: (CGFloat) angle;
+ (NSCursor *) threeProngedCursorForAngle: (CGFloat) angle withSize: (CGFloat) size;

+ (NSBezierPath *) angleCursorBezierPathForAngle: (CGFloat) angle;
+ (NSCursor *) angleCursorForAngle: (CGFloat) angle withSize: (CGFloat) size;

+ (NSBezierPath *) straightCursorBezierPathForAngle: (CGFloat) angle;
+ (NSCursor *) straightCursorForAngle: (CGFloat) angle withSize: (CGFloat) size;

+ (NSBezierPath *) halfStraightCursorBezierPathForAngle: (CGFloat) angle;
+ (NSCursor *) halfStraightCursorForAngle: (CGFloat) angle withSize: (CGFloat) size;




#pragma mark HELPER METHODS

/* 
	HELPER METHODS
 
	to do the actual drawing.
*/
+ (NSCursor *) cursorForBezierPath: (NSBezierPath *) path 
					  withRotation: (CGFloat) angle 
						   andSize: (CGFloat) size;

+ (NSCursor *) cursorForBezierPath: (NSBezierPath *) bP 
					  withRotation: (CGFloat) angle 
							  size: (CGFloat) size 
					   andUnderlay:(NSImage *) underlay;
@end
