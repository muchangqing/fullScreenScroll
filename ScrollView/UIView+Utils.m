//
//  Created by Josh Brown on 8/2/12.
//  Modified by yizhuolin on 14-1-1.
//  Copyright (c) 2012 Roadfire Software. All rights reserved.
//
#import <objc/runtime.h>
#import "UIView+Utils.h"


static NSString *const kDTActionHandlerTapGestureKey       = @"kDTActionHandlerTapGestureKey";
static NSString *const kDTActionHandlerTapBlockKey         = @"kDTActionHandlerTapBlockKey";
static NSString *const kDTActionHandlerLongPressGestureKey = @"kDTActionHandlerLongPressGestureKey";
static NSString *const kDTActionHandlerLongPressBlockKey   = @"kDTActionHandlerLongPressBlockKey";

@implementation UIView (Utils)

@dynamic cz_centerX;
@dynamic cz_centerY;
@dynamic cz_left;
@dynamic cz_top;
@dynamic cz_size;
@dynamic cz_height;
@dynamic cz_screenFrame;
@dynamic cz_right;
@dynamic cz_bottom;
@dynamic cz_width;
@dynamic cz_origin;
@dynamic cz_screenX;
@dynamic cz_screenY;
@dynamic cz_screenViewX;
@dynamic cz_screenViewY;
@dynamic cz_orientationWidth;
@dynamic cz_orientationHeight;

- (CGFloat)cz_left
{
    return self.frame.origin.x;
}
- (void)setCz_left:(CGFloat)cz_left
{
    CGRect frame = self.frame;
    frame.origin.x = cz_left;
    self.frame     = frame;
}

- (CGFloat)cz_top
{
    return self.frame.origin.y;
}
- (void)setCz_top:(CGFloat)cz_top
{
    CGRect frame = self.frame;
    frame.origin.y = cz_top;
    self.frame     = frame;
}


- (CGFloat)cz_right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setCz_right:(CGFloat)cz_right
{
    CGRect frame = self.frame;
    frame.origin.x = cz_right - frame.size.width;
    self.frame     = frame;

}

- (CGFloat)cz_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setCz_bottom:(CGFloat)cz_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = cz_bottom - frame.size.height;
    self.frame     = frame;
}

- (CGFloat)cz_centerX
{
    return self.center.x;
}
- (void)setCz_centerX:(CGFloat)cz_centerX
{
    self.center = CGPointMake(cz_centerX, self.center.y);
}

- (CGFloat)cz_centerY
{
    return self.center.y;
}
- (void)setCz_centerY:(CGFloat)cz_centerY
{
    self.center = CGPointMake(self.center.x, cz_centerY);
}


- (CGFloat)cz_width
{
    return self.frame.size.width;
}

- (void)setCz_width:(CGFloat)cz_width
{
    CGRect frame = self.frame;
    frame.size.width = cz_width;
    self.frame       = frame;
}

- (CGFloat)cz_height
{
    return self.frame.size.height;
}

- (void)setCz_height:(CGFloat)cz_height
{
    CGRect frame = self.frame;
    frame.size.height = cz_height;
    self.frame        = frame;
}

- (CGFloat)cz_screenX
{
    CGFloat     x     = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.cz_left;
    }
    return x;
}

- (CGFloat)cz_screenY
{
    CGFloat     y     = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        y += view.cz_top;
    }
    return y;
}

- (CGFloat)cz_screenViewX
{
    CGFloat     x     = 0.0f;
    for (UIView *view = self; view; view = view.superview) {
        x += view.cz_left;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            x -= scrollView.contentOffset.x;
        }
    }

    return x;
}

- (CGFloat)cz_screenViewY
{
    CGFloat     y     = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.cz_top;

        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


- (CGRect)cz_screenFrame
{
    return CGRectMake(self.cz_screenViewX, self.cz_screenViewY, self.cz_width, self.cz_height);
}


- (CGPoint)cz_origin
{
    return self.frame.origin;
}
- (void)setCz_origin:(CGPoint)cz_origin
{
    CGRect frame = self.frame;
    frame.origin = cz_origin;
    self.frame   = frame;
}



- (CGSize)cz_size
{
    return self.frame.size;
}

- (void)setCz_size:(CGSize)cz_size
{
    CGRect frame = self.frame;
    frame.size = cz_size;
    self.frame = frame;
}


- (CGFloat)cz_orientationWidth
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
                    ? self.cz_height : self.cz_width;
}


- (CGFloat)cz_orientationHeight
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
                    ? self.cz_width : self.cz_height;
}


- (UIView *)cz_descendantOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls]) {
        return self;
    }

    for (UIView *child in self.subviews) {
        UIView *it = [child cz_descendantOrSelfWithClass:cls];
        if (it) {
            return it;
        }
    }

    return nil;
}


- (UIView *)cz_ancestorOrSelfWithClass:(Class)cls
{
    if ([self isKindOfClass:cls]) {
        return self;

    } else if (self.superview) {
        return [self.superview cz_ancestorOrSelfWithClass:cls];

    } else {
        return nil;
    }
}


- (void)cz_removeAllSubviews
{
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


- (CGPoint)cz_offsetFromView:(UIView *)otherView
{
    CGFloat     x     = 0.0f, y = 0.0f;
    for (UIView *view = self; view && view != otherView; view = view.superview) {
        x += view.cz_left;
        y += view.cz_top;
    }
    return CGPointMake(x, y);
}


- (void)cz_setTapActionWithBlock:(void (^)(void))block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);

    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }

    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);

        if (action) {
            action();
        }
    }
}

- (void)cz_setLongPressActionWithBlock:(void (^)(void))block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerLongPressGestureKey);

    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kDTActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }

    objc_setAssociatedObject(self, &kDTActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerLongPressBlockKey);

        if (action) {
            action();
        }
    }
}

@end