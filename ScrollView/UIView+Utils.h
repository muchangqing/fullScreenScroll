//
// Created by yizhuolin on 14-1-1.
// Copyright 2013 {Company} Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (Utils)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property ( assign, nonatomic ) CGFloat cz_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property ( assign, nonatomic ) CGFloat cz_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property ( assign, nonatomic ) CGFloat cz_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property ( assign, nonatomic ) CGFloat cz_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property ( assign, nonatomic ) CGFloat cz_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property ( assign, nonatomic ) CGFloat cz_height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property ( assign, nonatomic ) CGFloat cz_centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property ( assign, nonatomic ) CGFloat cz_centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat cz_screenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat cz_screenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat cz_screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat cz_screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect cz_screenFrame;

/**
 * Shortcut for frame.origin
 */
@property ( assign, nonatomic ) CGPoint cz_origin;

/**
 * Shortcut for frame.size
 */
@property ( assign, nonatomic ) CGSize cz_size;

/**
 * Return the width in portrait or the height in landscape.
 */
@property (nonatomic, readonly) CGFloat cz_orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property (nonatomic, readonly) CGFloat cz_orientationHeight;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- ( UIView * )cz_descendantOrSelfWithClass:( Class )cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- ( UIView * )cz_ancestorOrSelfWithClass:( Class )cls;

/**
 * Removes all subviews.
 */
- ( void )cz_removeAllSubviews;

/**
 Attaches the given block for a single tap action to the receiver.
 @param block The block to execute.
 */
- ( void )cz_setTapActionWithBlock:( void (^)(void) )block;

/**
 Attaches the given block for a long press action to the receiver.
 @param block The block to execute.
 */
- ( void )cz_setLongPressActionWithBlock:( void (^)(void) )block;

@end