//
//  SFCollectionViewLayoutAttributes.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/18.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "SFCollectionViewLayoutAttributes.h"

@implementation SFCollectionViewLayoutAttributes

+ (instancetype)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind withIndexPath:(NSIndexPath *)indexPath {
    SFCollectionViewLayoutAttributes * layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    return layoutAttributes;
}

@end
