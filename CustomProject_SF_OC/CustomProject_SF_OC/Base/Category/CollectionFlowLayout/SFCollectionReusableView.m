//
//  SFCollectionReusableView.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/18.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "SFCollectionReusableView.h"
#import "SFCollectionViewLayoutAttributes.h"

@implementation SFCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    SFCollectionViewLayoutAttributes * layoutAttributesNew = (SFCollectionViewLayoutAttributes *)layoutAttributes;
    self.backgroundColor = layoutAttributesNew.color;
}

@end
