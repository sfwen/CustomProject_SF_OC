//
//  ReadBGController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/15.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadBGController.h"

@interface ReadBGController ()

@property (nonatomic, strong) UIImageView * imageView;

@end

@implementation ReadBGController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // imageView
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = FlatRed;
    self.imageView.frame = self.view.bounds;
    self.imageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    [self.view addSubview:self.imageView];
    
    if (self.targetView) {
//        self.imageView.image =
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
