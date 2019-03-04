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
    for (int i = 0; i < 3; i++) {
        [data addObject:[NSString stringWithFormat:@"%@", @(i)]];
    }
    
    [self handleRequestResult:data cache:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TestHorizontalRefreshViewController * vc = [[TestHorizontalRefreshViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    } else if (indexPath.row == 1) {
        AttributeViewController * vc = [[AttributeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    TestWaterViewController * vc = [[TestWaterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end