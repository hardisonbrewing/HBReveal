/* Copyright (c) 2013 Martin M Reed
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "UIView+HBReveal.h"

#import <objc/runtime.h>

@implementation UIView (HBReveal)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *containerView = objc_getAssociatedObject(self, "containerView");
    
    if (containerView)
    {
        CGRect bounds = self.bounds;
        bounds.size = CGSizeMake(bounds.size.width + containerView.bounds.size.width, bounds.size.height);
        
        if (CGRectContainsPoint(bounds, point)) {
            return YES;
        }
    }
    
    return CGRectContainsPoint(self.bounds, point);
}

- (UIView *)createcoverView
{
    UIView *coverView = [[UIView alloc] init];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hide)];
    [coverView addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(hide)];
    [coverView addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    
    return [coverView autorelease];
}

- (void)hide
{
    UIView *coverView = objc_getAssociatedObject(self, "coverView");
    
    for (UIGestureRecognizer *gestureRecognizer in coverView.gestureRecognizers) {
        [coverView removeGestureRecognizer:gestureRecognizer];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        
        CGRect frame = self.frame;
        frame.origin = CGPointMake(0, frame.origin.y);
        self.frame = frame;
        
        UIView *containerView = objc_getAssociatedObject(self, "containerView");
        UIView *contentView = [containerView.subviews objectAtIndex:0];
        CGRect contentFrame = contentView.frame;
        contentFrame.origin = CGPointMake(-1 * contentFrame.size.width, contentFrame.origin.y);
        contentView.frame = contentFrame;
        
    } completion:^(BOOL finished){
        
        UIView *coverView = objc_getAssociatedObject(self, "coverView");
        [coverView removeFromSuperview];
        
        UIView *containerView = objc_getAssociatedObject(self, "containerView");
        [containerView removeFromSuperview];
    }];
}

- (void)reveal:(UIView *)contentView
{
    if (!contentView)
    {
        [self hide];
        return;
    }
    
    UIView *containerView = [[UIView alloc] init];
    [containerView setAutoresizesSubviews:false];
    [containerView setClipsToBounds:true];
    [containerView addSubview:contentView];
    [self addSubview:containerView];
    objc_setAssociatedObject(self, "containerView", containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGRect frame = self.frame;
    
    UIView *coverView = [self createcoverView];
    coverView.frame = frame;
    [self addSubview:coverView];
    objc_setAssociatedObject(self, "coverView", coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGRect contentFrame = contentView.frame;
    contentFrame.origin = CGPointMake(-1 * contentFrame.size.width, contentFrame.origin.y);
    contentView.frame = contentFrame;
    
    CGRect containerFrame = containerView.frame;
    containerFrame.size = contentView.frame.size;
    containerFrame.origin = CGPointMake(frame.size.width, frame.origin.y);
    containerView.frame = containerFrame;
    
    [containerView release];
    
    [UIView animateWithDuration:0.25f animations:^{
        
        UIView *containerView = objc_getAssociatedObject(self, "containerView");
        UIView *contentView = [containerView.subviews objectAtIndex:0];
        CGRect contentFrame = contentView.frame;
        
        CGRect frame = self.frame;
        frame.origin = CGPointMake(-1 * contentFrame.size.width, frame.origin.y);
        self.frame = frame;
        
        contentFrame.origin = CGPointMake(0, frame.origin.y);
        contentView.frame = contentFrame;
        
    } completion:^(BOOL finished){}];
}

@end
