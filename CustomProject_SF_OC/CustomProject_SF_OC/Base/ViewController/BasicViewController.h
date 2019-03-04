//
//  BasicViewController.h
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController {
    BOOL _firstApper;
}

@property (strong, nonatomic) NSMutableArray * contentArray;

- (void)loadData;

@end
