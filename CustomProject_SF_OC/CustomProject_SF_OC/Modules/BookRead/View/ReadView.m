//
//  ReadView.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/15.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadView.h"
#import "ReadParser.h"

@interface ReadView ()

@property (nonatomic, assign) CTFrameRef frameRef;

@end

@implementation ReadView

- (void)setContent:(NSMutableAttributedString *)content {
    _content = content;
    if (content.length > 0 && content != nil) {
        self.frameRef = [ReadParser getReadFrameRefWithAttrString:content rect:CGRectMake(8, 0, ScreenWidth - 2 * kReadBookSpace_15 - 8, ScreenHeight - 2 * (kReadBookSpace_25 + kReadBookSpace_10))];
    }
}

- (void)setFrameRef:(CTFrameRef)frameRef {
    _frameRef = frameRef;
    if (frameRef != nil) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.frameRef == nil) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CTFrameDraw(self.frameRef, ctx);
}

@end
