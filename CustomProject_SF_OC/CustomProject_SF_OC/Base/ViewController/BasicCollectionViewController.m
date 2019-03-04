//
//  BasicCollectionViewController.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/15.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicCollectionViewController.h"

@interface BasicCollectionViewController ()


@end

@implementation BasicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base Method
- (NSString *)getReuseIdentifier {
    return @"BasicCollectionViewCell";
}

- (void)registerCollectionViewCell {
    [self.collectionView registerClass:NSClassFromString([self getReuseIdentifier]) forCellWithReuseIdentifier:[self getReuseIdentifier]];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BasicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self getReuseIdentifier] forIndexPath:indexPath];
    [cell configCellData:self.contentArray[indexPath.row]];
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        SFCollectionViewFlowLayout * flowLayout = [[SFCollectionViewFlowLayout alloc] init];
        flowLayout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
