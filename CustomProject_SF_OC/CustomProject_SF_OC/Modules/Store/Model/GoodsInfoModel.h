//
//  GoodsInfoModel.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/26.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicModel.h"
#import "PromotionModel.h"

@interface GoodsInfoModel : BasicModel

//@property (nonatomic, assign) id auditTime;
//@property (nonatomic, assign) id groupActivityTitle;
//@property (nonatomic, assign) id agentShopName;
@property (nonatomic, strong) NSString *mainImagePath;
//@property (nonatomic, assign) id groupBuyingVo;
@property (nonatomic, assign) double groupPeopleNumber;
@property (nonatomic, assign) double auditType;
//@property (nonatomic, assign) id lastOnlineTime;
//@property (nonatomic, assign) id groupPreTime;
@property (nonatomic, strong) NSString *refund;
@property (nonatomic, strong) NSString *price;
//@property (nonatomic, assign) id linkId;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSString *offlineTime;
@property (nonatomic, strong) NSString *regularPrice;
//@property (nonatomic, assign) id label;
//@property (nonatomic, assign) id oldTypeDictName;
//@property (nonatomic, assign) id endTime;
//@property (nonatomic, assign) id activityDate;
//@property (nonatomic, assign) id typeLabelState;
//@property (nonatomic, assign) id agentSid;
//@property (nonatomic, assign) id agentShopSid;
@property (nonatomic, assign) BOOL policyDefault;
@property (nonatomic, strong) NSString *groupTime;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *type;
//@property (nonatomic, assign) id groupNum;
@property (nonatomic, strong) NSString *costPrice;
//@property (nonatomic, assign) id groupCloseTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double merchantSpuNum;
@property (nonatomic, assign) double groupType;
@property (nonatomic, strong) NSString *groupLimitTime;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, assign) BOOL invoice;
@property (nonatomic, strong) NSString *wxPriceStateStr;
@property (nonatomic, strong) NSString *miniImagePath;
//@property (nonatomic, assign) id brandName;
@property (nonatomic, strong) NSString *stateName;
//@property (nonatomic, assign) id category1;
@property (nonatomic, assign) double refundNumber;
//@property (nonatomic, assign) id groupPurchase;
@property (nonatomic, assign) double groupForge;
@property (nonatomic, strong) NSString *oldTypeDictSid;
@property (nonatomic, assign) double benefit;
//@property (nonatomic, assign) id videoSid;
//@property (nonatomic, assign) id videoPath;
@property (nonatomic, assign) double version;
@property (nonatomic, assign) double benefitNumber;
//@property (nonatomic, assign) id category2;
@property (nonatomic, strong) NSString *onlineTime;
//@property (nonatomic, assign) id lastOfflineTime;
@property (nonatomic, strong) NSString *sellingPrice;
//@property (nonatomic, assign) id lessPeople;
@property (nonatomic, assign) double inventory;
//@property (nonatomic, assign) id refundOrderNumber;
//@property (nonatomic, assign) id category3;
@property (nonatomic, strong) NSString *shopName;
//@property (nonatomic, assign) id totalPeoNum;
@property (nonatomic, strong) NSString *employeeDiscount;
@property (nonatomic, strong) NSString *purchaseState;
//@property (nonatomic, assign) id typeLabelStateName;
//@property (nonatomic, assign) id systemTypeDict;
//@property (nonatomic, assign) id categoryName;
//@property (nonatomic, assign) id typeDictName;
@property (nonatomic, assign) BOOL greetingCard;
@property (nonatomic, assign) double groupDisplayOriginal;
@property (nonatomic, assign) double groupVirtualSales;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) BOOL newInventory;
//@property (nonatomic, assign) id spuvoCategories;
@property (nonatomic, assign) double spuSalesNumber;
//@property (nonatomic, assign) id groupBooking;
@property (nonatomic, strong) NSString *groupHeadDiscount;
//@property (nonatomic, assign) id firstOnlineTime;
//@property (nonatomic, assign) id activityType;
//@property (nonatomic, assign) id groupScope;
@property (nonatomic, strong) NSString *commonDiscount;
@property (nonatomic, strong) NSString *categorySid;
@property (nonatomic, assign) BOOL addPersonalPage;
@property (nonatomic, strong) NSString *employeePrice;
//@property (nonatomic, assign) id categoryParenSid;
@property (nonatomic, strong) PromotionModel *promotion;
@property (nonatomic, strong) NSString *state;
//@property (nonatomic, assign) id groupInventory;
//@property (nonatomic, assign) id groupBooked;
//@property (nonatomic, assign) id auditorSid;
@property (nonatomic, strong) NSString *groupTipContent;
@property (nonatomic, strong) NSString *merchantSid;
@property (nonatomic, strong) NSString *groupPrice;
@property (nonatomic, strong) NSString *invoiceType;
@property (nonatomic, strong) NSString *updatedTime;
//@property (nonatomic, assign) id groupRefundNumber;
@property (nonatomic, strong) NSString *purchasePrice;
@property (nonatomic, assign) BOOL ifPromotion;
@property (nonatomic, assign) double groupSalesNumber;
@property (nonatomic, strong) NSString *templateSid;
//@property (nonatomic, assign) id startTime;
//@property (nonatomic, assign) id groupCountDownOpen;
//@property (nonatomic, assign) id tbPrice;
@property (nonatomic, strong) NSString *dataDescription;
//@property (nonatomic, assign) id isRemind;
@property (nonatomic, assign) double wxPriceState;
@property (nonatomic, assign) BOOL overseas;
//@property (nonatomic, assign) id groupAllBook;
//@property (nonatomic, assign) id jdPrice;
@property (nonatomic, assign) double groupLimitDay;
@property (nonatomic, strong) NSString *groupStyle;
//@property (nonatomic, assign) id openTime;
@property (nonatomic, assign) BOOL ifGroupPurchase;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *groupDiscount;
//@property (nonatomic, assign) id subOfflineTime;
@property (nonatomic, strong) NSString *typeDictSid;
@property (nonatomic, strong) NSString *groupHeaderPrice;
@property (nonatomic, strong) NSString *groupAddTime;
@property (nonatomic, strong) NSString *shopSid;
@property (nonatomic, assign) double totalSalesNumber;
@property (nonatomic, strong) NSString *brandSid;
@property (nonatomic, assign) BOOL couponSpu;
//@property (nonatomic, assign) id templateVO;

@property (nonatomic, copy, readonly) NSMutableAttributedString * titleAttributedString;
@property (nonatomic, copy, readonly) NSMutableAttributedString * priceAttributedString;
@property (nonatomic, copy, readonly) NSMutableAttributedString * remarkAttributedString;

@end
