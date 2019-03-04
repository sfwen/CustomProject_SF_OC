//
//  SFCollectionViewFlowLayout.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/18.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "SFCollectionViewFlowLayout.h"
#import "CellFakeView.h"
#import "SFCollectionViewLayoutAttributes.h"

typedef NS_ENUM(NSInteger, SFScrollDirction) {
    SFScrollDirction_Stay,
    SFScrollDirction_ToTop,
    SFScrollDirction_ToEnd,
};

@interface SFCollectionViewFlowLayout () <UIGestureRecognizerDelegate>

/** 每个section的每一列的高度 */
@property (nonatomic, retain) NSMutableArray * collectionHeightsArray;
/** 存放每一个cell的属性 */
@property (nonatomic, retain) NSMutableArray * attributesArray;

#pragma mark - 拖动相关参数
@property (nonatomic, strong) CellFakeView * cellFakeView;
@property (nonatomic, strong) UILongPressGestureRecognizer * longPress;
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic, assign) CGPoint fakeCellCenter;
@property (nonatomic, assign) CGPoint panTranslation;
@property (nonatomic, assign) SFScrollDirction continuousSctollDirection;
@property (nonatomic, strong) CADisplayLink * displayLink;

@end

@implementation SFCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isFloor = YES;
        self.canDrag = NO;
        self.headerSuspension = NO;
        self.layoutType = CollectionViewLayoutType_FillLayout;
        self.columnCount = 1;
        [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - 当尺寸发生变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

+ (Class)layoutAttributesClass {
    return [SFCollectionViewLayoutAttributes class];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"collectionView"];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat totalWidth = self.collectionView.frame.size.width;
    CGFloat x = 0, y = 0, headerH = 0, footerH = 0;
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    CGFloat minimunLineSpacing = 0, minimunInteritemSpacing = 0;
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    self.attributesArray = [NSMutableArray arrayWithCapacity:1];
    self.collectionHeightsArray = [NSMutableArray arrayWithCapacity:sectionCount];
    
    for (int index = 0; index < sectionCount; index++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:index];
        //头部
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
            headerH = [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:index].height;
        } else {
            headerH = self.headerReferenceSize.height;
        }
        
        //尾部
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
            footerH = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:index].height;
        } else {
            footerH = self.footerReferenceSize.height;
        }
        
        //edge
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
        } else {
            edgeInsets = self.sectionInset;
        }
        
        //minimumLineSpacing
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
            minimunLineSpacing = [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:index];
        } else {
            minimunLineSpacing = self.minimumLineSpacing;
        }
        
        //minimumInteritemSpacing
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
            minimunInteritemSpacing = [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:index];
        } else {
            minimunInteritemSpacing = self.minimumInteritemSpacing;
        }
        
        //头部视图
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:registerBackView:)]) {
            NSString * className = [self.delegate collectionView:self.collectionView layout:self registerBackView:index];
            if (className != nil && className.length > 0) {
                NSAssert([[NSClassFromString(className) alloc] init] != nil, @"代理collectionView:layout:registerBackView:里面必须返回有效的类名!");
                [self registerClass:NSClassFromString(className) forDecorationViewOfKind:className];
            } else {
                [self registerClass:[SFCollectionReusableView class] forDecorationViewOfKind:@"SFCollectionReusableView"];
            }
        }
        
        x = edgeInsets.left;
        y = [self maxHeightWithSection:index];
        
        //添加首页属性
        if (headerH > 0) {
            NSIndexPath * headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
            SFCollectionViewLayoutAttributes * headerAttribute = [SFCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
            headerAttribute.frame = CGRectMake(0, y, CGRectGetWidth(self.collectionView.frame), headerH);
            [self.attributesArray addObject:headerAttribute];
        }
        
        y += headerH;
        CGFloat itemStartY = y, lastY = y;
        
        if (itemCount > 0) {
            y += edgeInsets.top;
            //layoutType
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:typeOfLayout:)]) {
                self.layoutType = [self.delegate collectionView:self.collectionView layout:self typeOfLayout:index];
            }
            
            //columnCount
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:columnCountOfSection:)]) {
                self.columnCount = [self.delegate collectionView:self.collectionView layout:self columnCountOfSection:index];
            }
            
            //定义一个列高数组  记录每一列的总高度
            //分配个地址
            CGFloat * columnHeight = (CGFloat *)malloc(self.columnCount * sizeof(CGFloat));
            CGFloat itemWidth = 0.0;
            if (self.layoutType == CollectionViewLayoutType_ClosedLayout) {
                for (int i = 0; i < self.columnCount; i++) {
                    columnHeight[i] = y;
                }
                itemWidth = (totalWidth - edgeInsets.left - edgeInsets.right - minimunInteritemSpacing * (self.columnCount - 1)) / self.columnCount;
            }
            
            CGFloat maxYOfPercent = y, maxYOfFill = y;
            NSMutableArray * arrayOfPercent = [NSMutableArray new], * arrayOfFill = [NSMutableArray new], * arrayOfAbsolute = [NSMutableArray new];
            for (int i = 0; i < itemCount; i++) {
                NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:index];
                CGSize itemSize = CGSizeZero;
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
                    itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
                } else {
                    itemSize = self.itemSize;
                }
                SFCollectionViewLayoutAttributes * attributes = [SFCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                NSInteger preRow = self.attributesArray.count - 1;
                switch (self.layoutType) {
#pragma mark - 标签布局
                    case CollectionViewLayoutType_LabelLayout: {
                        //找到上一个cell
                        if (preRow >= 0) {
                            if (i > 0) {
                                SFCollectionViewLayoutAttributes * preAttr = self.attributesArray[preRow];
                                x = preAttr.frame.origin.x + preAttr.frame.size.width + minimunInteritemSpacing;
                                if (x + itemSize.width > totalWidth - edgeInsets.right) {
                                    x = edgeInsets.left;
                                    y += itemSize.height + minimunLineSpacing;
                                }
                            }
                        }
                        attributes.frame = CGRectMake(x, y, itemSize.width, itemSize.height);
                    }
                        break;
#pragma mark - 列布局
                    case CollectionViewLayoutType_ClosedLayout: {
                        CGFloat max = CGFLOAT_MAX;
                        NSInteger column = 0;
                        for (int i = 0; i < self.columnCount; i++) {
                            if (columnHeight[i] < max) {
                                max = columnHeight[i];
                                column = i;
                            }
                        }
                        CGFloat itemX = edgeInsets.left + (itemWidth + minimunInteritemSpacing) * column;
                        CGFloat itemY = columnHeight[column];
                        attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemSize.height);
                        columnHeight[column] += (itemSize.height + minimunLineSpacing);
                    }
                        break;
#pragma mark - 百分比布局
                    case CollectionViewLayoutType_PercentLayout: {
                        CGFloat percent = 0.0f;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:percentOfRow:)]) {
                            percent = [self.delegate collectionView:self.collectionView layout:self percentOfRow:indexPath];
                        } else {
                            percent = 1;
                        }
                        if (percent > 1 || percent <= 0) {
                            percent = 1;
                        }
                        if (arrayOfPercent.count > 0) {
                            CGFloat totalPercent = 0;
                            for (NSDictionary * dic in arrayOfPercent) {
                                totalPercent += [dic[@"percent"] floatValue];
                            }
                            
                            CGFloat a = totalPercent + percent;
                            if (a >= 1.0) {
                                if (a < 1.1) {
                                    //小于1.1当成1行计算
                                    //先添加进总的数组
                                    attributes.indexPath = indexPath;
                                    attributes.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
                                    //再添加进计算比例的数组
                                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                                    [dict setObject:attributes forKey:@"item"];
                                    [dict setObject:@(percent) forKey:@"percent"];
                                    [dict setObject:indexPath forKey:@"indexPath"];
                                    [arrayOfPercent addObject:dict];
                                    
                                    if (a > 1) {
                                        NSMutableDictionary * lastDic = [NSMutableDictionary dictionaryWithDictionary:arrayOfPercent.lastObject];
                                        CGFloat lastPercent = 1.0;
                                        for (int i = 0; i < arrayOfPercent.count - 1; i++) {
                                            NSMutableDictionary * dic = arrayOfPercent[i];
                                            lastPercent -= [dic[@"percent"] floatValue];
                                        }
                                        lastDic[@"percent"] = @(lastPercent);
                                        [arrayOfPercent replaceObjectAtIndex:arrayOfPercent.count - 1 withObject:lastDic];
                                    }
                                    
                                    CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - (arrayOfPercent.count - 1) * minimunInteritemSpacing;
                                    for (int i = 0; i < arrayOfPercent.count; i++) {
                                        NSDictionary * dic = arrayOfPercent[i];
                                        SFCollectionViewLayoutAttributes * newAttr = dic[@"item"];
                                        CGFloat itemX = 0.0;
                                        if (i == 0) {
                                            itemX = edgeInsets.left;
                                        } else {
                                            SFCollectionViewLayoutAttributes * preAttr = arrayOfPercent[i - 1][@"item"];
                                            itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimunInteritemSpacing;
                                        }
                                        
                                        newAttr.frame = CGRectMake(itemX, maxYOfPercent + minimunLineSpacing, realWidth * [dic[@"percent"] floatValue], newAttr.frame.size.height);
                                        newAttr.indexPath = dic[@"indexPath"];
                                        [self.attributesArray addObject:newAttr];
                                    }
                                    
                                    for (int i = 0; i < arrayOfPercent.count; i++) {
                                        NSDictionary * dic = arrayOfPercent[i];
                                        SFCollectionViewLayoutAttributes * item = dic[@"item"];
                                        if (item.frame.origin.y + item.frame.size.height > maxYOfPercent) {
                                            maxYOfPercent = item.frame.origin.y + item.frame.size.height;
                                        }
                                    }
                                    [arrayOfPercent removeAllObjects];
                                } else {
                                    //先添加进总的数组
                                    attributes.indexPath = indexPath;
                                    attributes.frame = CGRectMake(0, maxYOfPercent, itemSize.width, itemSize.height);
                                    //再添加进计算比例的数组
                                    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                                    [dict setObject:attributes forKey:@"item"];
                                    [dict setObject:@(percent) forKey:@"percent"];
                                    [dict setObject:indexPath forKey:@"indexPath"];
                                    [arrayOfPercent addObject:dict];
                                    
                                    //如果该行item总比例小于1，但是item已经是最后一个
                                    if (i == itemCount - 1) {
                                        CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - (arrayOfPercent.count - 1) * minimunInteritemSpacing;
                                        for (int i = 0; i < arrayOfPercent.count; i++) {
                                            NSDictionary * dic = arrayOfPercent[i];
                                            SFCollectionViewLayoutAttributes * newAttr = dic[@"item"];
                                            CGFloat itemX = 0.0f;
                                            if (i == 0) {
                                                itemX = edgeInsets.left;
                                            } else {
                                                SFCollectionViewLayoutAttributes * preAttr = arrayOfPercent[i - 1][@"item"];
                                                itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimunInteritemSpacing;
                                            }
                                            newAttr.frame = CGRectMake(itemX, maxYOfPercent + minimunLineSpacing, realWidth * [dic[@"percent"] floatValue], newAttr.frame.size.height);
                                            newAttr.indexPath = dic[@"indexPath"];
                                            [self.attributesArray addObject:newAttr];
                                        }
                                        
                                        for (int i = 0; i < arrayOfPercent.count; i++) {
                                            NSDictionary * dic = arrayOfPercent[i];
                                            SFCollectionViewLayoutAttributes * item = dic[@"item"];
                                            if (item.frame.origin.y + item.frame.size.height > maxYOfPercent) {
                                                maxYOfPercent = item.frame.origin.y + item.frame.size.height;
                                            }
                                        }
                                        [arrayOfPercent removeAllObjects];
                                    }
                                }
                            } else {
                                //先添加进总数组
                                attributes.indexPath = indexPath;
                                NSDictionary * lastDicForPercent = arrayOfPercent[arrayOfPercent.count - 1];
                                SFCollectionViewLayoutAttributes * lastAttributesForPercent = lastDicForPercent[@"item"];
                                attributes.frame = CGRectMake(lastAttributesForPercent.frame.origin.x + lastAttributesForPercent.frame.size.width + minimunInteritemSpacing, lastAttributesForPercent.frame.origin.y, itemSize.width, itemSize.height);
                                //再添加进计算比例的数组
                                NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                                [dict setObject:attributes forKey:@"item"];
                                [dict setObject:@(percent) forKey:@"percent"];
                                [dict setObject:indexPath forKey:@"indexPath"];
                                [arrayOfPercent addObject:dict];
                                
                                //如果已经是最后一个
                                if (i == itemCount - 1) {
                                    CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - (arrayOfPercent.count - 1) * minimunInteritemSpacing;
                                    for (int i = 0; i < arrayOfPercent.count; i++) {
                                        NSDictionary * dic = arrayOfPercent[i];
                                        SFCollectionViewLayoutAttributes * newAttr = dic[@"item"];
                                        CGFloat itemX = 0.0f;
                                        if (i == 0) {
                                            itemX = edgeInsets.left;
                                        } else {
                                            SFCollectionViewLayoutAttributes * preAttr = arrayOfPercent[i - 1][@"item"];
                                            itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimunInteritemSpacing;
                                        }
                                        
                                        newAttr.frame = CGRectMake(itemX, maxYOfPercent + minimunLineSpacing, realWidth * [dic[@"percent"] floatValue], newAttr.frame.size.height);
                                        newAttr.indexPath = dic[@"indexPath"];
                                        [self.attributesArray addObject:newAttr];
                                    }
                                    
                                    for (int i = 0; i < arrayOfPercent.count; i++) {
                                        NSDictionary * dic = arrayOfPercent[i];
                                        SFCollectionViewLayoutAttributes * item = dic[@"item"];
                                        if (item.frame.origin.y + item.frame.size.height > maxYOfPercent) {
                                            maxYOfPercent = item.frame.origin.y + item.frame.size.height;
                                        }
                                    }
                                    [arrayOfPercent removeAllObjects];
                                }
                            }
                        } else {
                            //先添加进总的数组
                            attributes.indexPath = indexPath;
                            attributes.frame = CGRectMake(edgeInsets.left, maxYOfPercent + minimunLineSpacing, itemSize.width, itemSize.height);
                            //再添加进计算比例的数组
                            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
                            [dict setObject:attributes forKey:@"item"];
                            [dict setObject:@(percent) forKey:@"percent"];
                            [dict setObject:indexPath forKey:@"indexPath"];
                            [arrayOfPercent addObject:dict];
                            
                            //如果已经是最后一个
                            if (i == itemCount - 1) {
                                CGFloat realWidth = totalWidth - edgeInsets.left - edgeInsets.right - (arrayOfPercent.count - 1) * minimunInteritemSpacing;
                                for (int i = 0; i < arrayOfPercent.count; i++) {
                                    NSDictionary * dic = arrayOfPercent[i];
                                    SFCollectionViewLayoutAttributes * newAttr = dic[@"item"];
                                    CGFloat itemX = 0.0f;
                                    if (i == 0) {
                                        itemX = edgeInsets.left;
                                    } else {
                                        SFCollectionViewLayoutAttributes * preAttr = arrayOfPercent[i - 1][@"item"];
                                        itemX = preAttr.frame.origin.x + preAttr.frame.size.width + minimunInteritemSpacing;
                                    }
                                    
                                    newAttr.frame = CGRectMake(itemX, maxYOfPercent + minimunLineSpacing, realWidth * [dic[@"percent"] floatValue], newAttr.frame.size.height);
                                    [self.attributesArray addObject:newAttr];
                                }
                                
                                for (int i = 0; i < arrayOfPercent.count; i++) {
                                    NSDictionary * dic = arrayOfPercent[i];
                                    SFCollectionViewLayoutAttributes * item = dic[@"item"];
                                    if (item.frame.origin.y + item.frame.size.height > maxYOfPercent) {
                                        maxYOfPercent = item.frame.origin.y + item.frame.size.height;
                                    }
                                }
                                [arrayOfPercent removeAllObjects];
                            }
                        }
                    }
                        break;
#pragma mark - 填充式布局
                    case CollectionViewLayoutType_FillLayout: {
                        if (arrayOfPercent.count == 0) {
                            attributes.frame = CGRectMake(edgeInsets.left, maxYOfFill, self.isFloor ? floor(itemSize.width) : itemSize.width, self.isFloor ? floor(itemSize.height) : itemSize.height);
                            [arrayOfFill addObject:attributes];
                        } else {
                            NSMutableArray * x_arrayOfFill = [NSMutableArray new];
                            [x_arrayOfFill addObject:@(edgeInsets.left)];
                            NSMutableArray * y_arrayOfFill = [NSMutableArray new];
                            [y_arrayOfFill addObject:self.isFloor ? @(floor(maxYOfFill)) : @(maxYOfFill)];
                            for (SFCollectionViewLayoutAttributes * attr in arrayOfFill) {
                                CGFloat x_a = attr.frame.origin.x;
                                if (![x_arrayOfFill containsObject:@(x_a)]) {
                                    [x_arrayOfFill addObject:@(x_a)];
                                }
                                CGFloat right_a = attr.frame.origin.x + attr.frame.size.width;
                                if (![x_arrayOfFill containsObject:@(right_a)]) {
                                    [x_arrayOfFill addObject:@(right_a)];
                                }
                                CGFloat y_a = attr.frame.origin.y;
                                if (![y_arrayOfFill containsObject:@(y_a)]) {
                                    [y_arrayOfFill addObject:@(y_a)];
                                }
                                CGFloat bottom_a = attr.frame.origin.y + attr.frame.size.height;
                                if (![y_arrayOfFill containsObject:@(bottom_a)]) {
                                    [y_arrayOfFill addObject:@(bottom_a)];
                                }
                            }
                            
                            [x_arrayOfFill sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                return [obj1 floatValue] > [obj2 floatValue];
                            }];
                            [y_arrayOfFill sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                return [obj1 floatValue] > [obj2 floatValue];
                            }];
                            
                            BOOL qualified = YES;
                            for (NSNumber * y_f in y_arrayOfFill) {
                                for (NSNumber * x_f in x_arrayOfFill) {
                                    qualified = YES;
                                    attributes.frame = CGRectMake(x_f.floatValue == edgeInsets.left ? x_f.floatValue : x_f.floatValue + minimunInteritemSpacing, y_f.floatValue == maxYOfFill ? (self.isFloor ? floor(y_f.floatValue) : y_f.floatValue) : y_f.floatValue + minimunLineSpacing, self.isFloor ? floor(itemSize.width) : itemSize.width, self.isFloor ? floor(itemSize.height) : itemSize.height);
                                    if (attributes.frame.origin.x + attributes.frame.size.width > totalWidth - edgeInsets.right) {
                                        qualified = NO;
                                        break;
                                    }
                                    for (SFCollectionViewLayoutAttributes * attr in arrayOfFill) {
                                        if (CGRectIntersectsRect(attributes.frame, attr.frame)) {
                                            qualified = NO;
                                            break;
                                        }
                                    }
                                    if (qualified == NO) {
                                        continue;
                                    } else {
                                        CGPoint leftPt = CGPointMake(attributes.frame.origin.x - minimunInteritemSpacing, attributes.frame.origin.y);
                                        CGRect leftRect = CGRectZero;
                                        for (SFCollectionViewLayoutAttributes * attr in arrayOfFill) {
                                            if (CGRectContainsPoint(attr.frame, leftPt)) {
                                                leftRect = attr.frame;
                                                break;
                                            }
                                        }
                                        if (CGRectEqualToRect(leftRect, CGRectZero)) {
                                            break;
                                        } else {
                                            if (attributes.frame.origin.x - leftRect.origin.x - leftRect.size.width == minimunInteritemSpacing) {
                                                break;
                                            } else {
                                                CGRect rc = attributes.frame;
                                                rc.origin.x = leftRect.origin.x + leftRect.size.width + minimunInteritemSpacing;
                                                attributes.frame = rc;
                                                for (SFCollectionViewLayoutAttributes * attr in arrayOfFill) {
                                                    if (CGRectIntersectsRect(attributes.frame, attr.frame)) {
                                                        qualified = NO;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if (qualified) {
                                    break;
                                }
                            }
                             [arrayOfFill addObject:attributes];
                        }
                    }
                        break;
#pragma mark - 绝对定位布局
                    case CollectionViewLayoutType_AbsoluteLayout: {
                        CGRect itemFrame = CGRectZero;
                        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:rectOfItem:)]) {
                            itemFrame = [self.delegate collectionView:self.collectionView layout:self rectOfItem:indexPath];
                        }
                        CGFloat x_abs = edgeInsets.left + itemFrame.origin.x;
                        CGFloat y_abs = y + itemFrame.origin.y;
                        CGFloat w_abs = itemFrame.size.width;
                        
                        if (x_abs + w_abs > self.collectionView.frame.size.width - edgeInsets.right && x_abs < self.collectionView.frame.size.width - edgeInsets.right) {
                            w_abs -= (x_abs + w_abs - (self.collectionView.frame.size.width - edgeInsets.right));
                        }
                        
                        CGFloat h_abs = itemFrame.size.height;
                        attributes.frame = CGRectMake(x_abs, y_abs, w_abs, h_abs);
                        [arrayOfAbsolute addObject:attributes];
                    }
                        break;
                        
                    default:
                        break;
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:transformOfItem:)]) {
                    attributes.transform3D = [self.delegate collectionView:self.collectionView layout:self transformOfItem:indexPath];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:zIndexOfItem:)]) {
                    attributes.zIndex = [self.delegate collectionView:self.collectionView layout:self zIndexOfItem:indexPath];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:alphaOfItem:)]) {
                    attributes.alpha = [self.delegate collectionView:self.collectionView layout:self alphaOfItem:indexPath];
                }
                
                attributes.indexPath = indexPath;
                if (self.layoutType != CollectionViewLayoutType_PercentLayout) {
                    [self.attributesArray addObject:attributes];
                }
                
                if (self.layoutType == CollectionViewLayoutType_ClosedLayout) {
                    CGFloat max = 0;
                    for (int i = 0; i < self.columnCount; i++) {
                        max = MAX(columnHeight[i], max);
                    }
                    lastY = max;
                } else if (self.layoutType == CollectionViewLayoutType_PercentLayout) {
                    lastY = maxYOfPercent;
                } else if (self.layoutType == CollectionViewLayoutType_FillLayout) {
                    if (i == itemCount - 1) {
                        for (SFCollectionViewLayoutAttributes * attr in arrayOfFill) {
                            maxYOfFill = MAX(maxYOfFill, attr.frame.origin.y + attr.frame.size.height);
                        }
                    }
                    lastY = maxYOfFill;
                } else if (self.layoutType == CollectionViewLayoutType_AbsoluteLayout) {
                    if (i == itemCount - 1) {
                        for (SFCollectionViewLayoutAttributes * attr in arrayOfAbsolute) {
                            lastY = MAX(attr.frame.origin.y + attr.frame.size.height, lastY);
                        }
                    }
                } else {
                    lastY = attributes.frame.origin.y + attributes.frame.size.height;
                }
            }
        }
        lastY += edgeInsets.bottom;
        
        BOOL isAttachToTop = [self isAttachToTop:index];
        NSIndexPath * headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        SFCollectionViewLayoutAttributes * headerAttr;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:registerBackView:)]) {
            NSString * className = [self.delegate collectionView:self.collectionView layout:self registerBackView:index];
            
            if (className != nil && className.length > 0) {
                headerAttr = [SFCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:className withIndexPath:headerIndexPath];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:loadView:)]) {
                    [self.delegate collectionView:self.collectionView layout:self loadView:index];
                }
            } else {
                headerAttr = [self setDefaultCollectionViewLayoutAttributesWithIndexPath:headerIndexPath];
            }
        } else {
            headerAttr = [self setDefaultCollectionViewLayoutAttributesWithIndexPath:headerIndexPath];
        }
        
        headerAttr.frame = CGRectMake(0, isAttachToTop ? itemStartY - headerH : itemStartY, self.collectionView.frame.size.width, lastY - itemStartY + (isAttachToTop ? headerH : 0));
        headerAttr.zIndex = -1000;
        [self.attributesArray addObject:headerAttr];
        
        //添加Footer属性
        if (footerH > 0) {
            NSIndexPath * footerIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
            SFCollectionViewLayoutAttributes * footerAttr = [SFCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerIndexPath];
            footerAttr.frame = CGRectMake(0, lastY, self.collectionView.frame.size.width, footerH);
            [self.attributesArray addObject:footerAttr];
            lastY += footerH;
        }
        _collectionHeightsArray[index] = [NSNumber numberWithFloat:lastY];
    }
}

- (SFCollectionViewLayoutAttributes *)setDefaultCollectionViewLayoutAttributesWithIndexPath:(NSIndexPath *)indexPath {
    SFCollectionViewLayoutAttributes *attr = [SFCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:@"SFCollectionReusableView" withIndexPath:indexPath];
    attr.color = self.collectionView.backgroundColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:backColorForSection:)]) {
        attr.color = [self.delegate collectionView:self.collectionView layout:self backColorForSection:indexPath.section];
    }
    return attr;
}


- (BOOL)isAttachToTop:(NSInteger)section {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:attachToTop:)]) {
        return [self.delegate collectionView:self.collectionView layout:self attachToTop:section];
    }
    return NO;
}

#pragma mark - 所有cell和view的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.attributesArray) {
        return [super layoutAttributesForElementsInRect:rect];
    } else {
        if (self.headerSuspension) {
            for (UICollectionViewLayoutAttributes * attribute in self.attributesArray) {
                if (![attribute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                    continue;
                }
                NSInteger section = attribute.indexPath.section;
                CGRect frame = attribute.frame;
                if (section == 0) {
                    if (self.collectionView.contentOffset.y > 0 && self.collectionView.contentOffset.y < [self.collectionHeightsArray[0] floatValue]) {
                        frame.origin.y = self.collectionView.contentOffset.y;
                    }
                } else {
                    if (self.collectionView.contentOffset.y > [self.collectionHeightsArray[section - 1] floatValue] && self.collectionView.contentOffset.y < [self.collectionHeightsArray[section] floatValue]) {
                        frame.origin.y = self.collectionView.contentOffset.y;
                    }
                }
                attribute.zIndex = 1000 + section;
                attribute.frame = frame;
            }
        }
        return self.attributesArray;
    }
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize {
    CGFloat footerH = 0.0f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        footerH = [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:self.collectionHeightsArray.count - 1].height;
    } else {
        footerH = self.footerReferenceSize.height;
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:self.collectionHeightsArray.count - 1];
    } else {
        edgeInsets = self.sectionInset;
    }
    
    if (self.collectionHeightsArray.count > 0) {
        return CGSizeMake(self.collectionView.frame.size.width, [self.collectionHeightsArray[self.collectionHeightsArray.count - 1] floatValue]);
    } else {
        return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }
}

/**
 每个区的初始Y坐标
 @param section 区索引
 @return Y坐标
 */
- (CGFloat)maxHeightWithSection:(NSInteger)section {
    if (section > 0) {
        return [self.collectionHeightsArray[section - 1] floatValue];
    } else {
        return 0;
    }
}

#pragma mark - 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"collectionView"]) {
        if (self.canDrag) {
            [self setUpGestureRecognizers];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 以下是拖动排序的代码
- (void)setCanDrag:(BOOL)canDrag {
    _canDrag = canDrag;
//    if (canDrag) {
//        if (self.longPress == nil && self.panGesture == nil) {
//            [self setUpGestureRecognizers];
//        }
//    } else {
//        [self.collectionView removeGestureRecognizer:self.longPress];
//        self.longPress.delegate = nil;
//        self.longPress = nil;
//
//        [self.collectionView removeGestureRecognizer:self.panGesture];
//        self.panGesture.delegate = nil;
//        self.panGesture = nil;
//    }
}

- (void)setUpGestureRecognizers {
    if (self.collectionView == nil) {
        return;
    }
    
//    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
//    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
//    self.longPress.delegate = self;
//    self.panGesture.delegate = self;
//    self.panGesture.maximumNumberOfTouches = 1;
//    NSArray *gestures = [self.collectionView gestureRecognizers];
//    
//    __weak typeof(SFCollectionViewFlowLayout *) weakSelf = self;
//    [gestures enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[UILongPressGestureRecognizer class]]) {
//            [(UILongPressGestureRecognizer *)obj requireGestureRecognizerToFail:weakSelf.longPress];
//        }
//    }];
//    [self.collectionView addGestureRecognizer:self.longPress];
//    [self.collectionView addGestureRecognizer:self.panGesture];
}

@end
