//
//  SFCollectionViewFlowLayout.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/18.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCollectionReusableView.h"

typedef NS_ENUM(NSInteger, CollectionViewLayoutType) {
    CollectionViewLayoutType_Base = 0,//基础布局，默认苹果UICollectionView的布局
    CollectionViewLayoutType_LabelLayout = 1,//标签布局
    CollectionViewLayoutType_ClosedLayout = 2,//列布局 指定列数，按列数来等分一整行，itemSize的width可以任意写，在布局中自动计算。可用于瀑布流
    CollectionViewLayoutType_PercentLayout = 3,//百分比布局 需要实现percentOfRow的代理，根据设定值来计算每个itemSize的宽度
    CollectionViewLayoutType_FillLayout = 4,//填充式布局 将一堆大小不一的view见缝插针的填充到一个平面内，规则为先判断从左到右是否有间隙填充，再从上到下判断
    CollectionViewLayoutType_AbsoluteLayout = 5,//绝对定位布局 需实现rectOfItem的代理，指定每个item的frame
};

@class SFCollectionViewFlowLayout;

@protocol SFCollectionViewFlowLayoutDelegate <NSObject>

@optional
//指定是什么布局，如没有指定则为BaseLayout(基础布局)
- (CollectionViewLayoutType)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section;

#pragma mark - 同基础UICollectionView的代理设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark -
/******** 设置每个section的背景色 ***********/
//设置每个section的背景色
- (UIColor*)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout backColorForSection:(NSInteger)section;

//对section背景进行一些操作
- (void)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout loadView:(NSInteger)section;

//背景是否延伸覆盖到headerView，默认为NO
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout attachToTop:(NSInteger)section;
/**
 自定义section的背景View，需要继承UICollectionReusableView
 
 @return 类名
 */
- (NSString*)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout registerBackView:(NSInteger)section;

/******** 提取出UICollectionViewLayoutAttributes的一些属性 ***********/
//设置每个item的zIndex，不指定默认为0
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout zIndexOfItem:(NSIndexPath*)indexPath;
//设置每个item的CATransform3D，不指定默认为CATransform3DIdentity
- (CATransform3D)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout transformOfItem:(NSIndexPath*)indexPath;
//设置每个item的alpha，不指定默认为1
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout alphaOfItem:(NSIndexPath*)indexPath;

/******** CollectionViewLayoutType_ClosedLayout列布局需要的代理 ***********/
//在CollectionViewLayoutType_ClosedLayout列布局中指定一行有几列，不指定默认为1列
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout *)collectionViewLayout columnCountOfSection:(NSInteger)section;

/******** CollectionViewLayoutType_PercentLayout百分比布局需要的代理 ***********/
//在CollectionViewLayoutType_PercentLayout百分比布局中指定每个item占该行的几分之几，如3.0/4，注意为大于0小于等于1的数字。不指定默认为1
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout percentOfRow:(NSIndexPath*)indexPath;

/******** CollectionViewLayoutType_AbsoluteLayout绝对定位布局需要的代理 ***********/
//在CollectionViewLayoutType_AbsoluteLayout绝对定位布局中指定每个item的frame，不指定默认为CGRectZero
- (CGRect)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout rectOfItem:(NSIndexPath*)indexPath;

/******** 拖动cell的相关代理 ***************************/
- (void)collectionView:(UICollectionView *)collectionView layout:(SFCollectionViewFlowLayout*)collectionViewLayout didMoveCell:(NSIndexPath*)atIndexPath toIndexPath:(NSIndexPath*)toIndexPath;

@end

@interface SFCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) id <SFCollectionViewFlowLayoutDelegate> delegate;
/**
 宽度是否向下取整
 默认YES，用于填充布局、百分比布局
 */
@property (nonatomic, assign) BOOL isFloor;

/**
 是否允许拖动cell，默认NO
 */
@property (nonatomic, assign) BOOL canDrag;

/**
 头部是否悬停，默认NO
 */
@property (nonatomic, assign) BOOL headerSuspension;

/**
 指定列数
 */
@property (nonatomic, assign) NSInteger columnCount;

@property (nonatomic, assign) CollectionViewLayoutType layoutType;

@end
