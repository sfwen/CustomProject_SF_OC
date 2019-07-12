//
//  MeMainViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/6.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "MeMainViewController.h"
#import "TestWaterViewController.h"
#import "TestHorizontalRefreshViewController.h"
#import "AttributeViewController.h"
#import "ChartsViewController.h"

@interface MeMainViewController ()

@end

@implementation MeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    NSMutableArray * data = [NSMutableArray new];
    for (int i = 0; i < 4; i++) {
        [data addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    
    [self handleRequestResult:data cache:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BasicViewController * vc;
    if (indexPath.row == 0) {
        vc = [[TestHorizontalRefreshViewController alloc] init];
    } else if (indexPath.row == 1) {
        vc = [[AttributeViewController alloc] init];
    } else if (indexPath.row == 3) {
        vc = [[ChartsViewController alloc] init];
    } else {
        vc = [[TestWaterViewController alloc] init];
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
