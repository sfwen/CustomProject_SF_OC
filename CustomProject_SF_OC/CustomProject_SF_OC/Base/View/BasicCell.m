//
//  BasicCell.m
//  CustomProject_SF_OC
//
//  Created by Land on 2018/12/11.
//  Copyright © 2018年 sfwen. All rights reserved.
//

#import "BasicCell.h"

@implementation BasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellData:(id)model {
    self.textLabel.text = [NSString stringWithFormat:@"%@", model];
}

- (NSAttributedString *)getAttributeString:(CGFloat)fontSize {
    NSDictionary *titleNodeAttributes = @{
                                          NSFontAttributeName : APPFONT(fontSize),
                                          NSForegroundColorAttributeName : Color_Block_51
                                          };
    return [[NSAttributedString alloc] initWithString:@"" attributes:titleNodeAttributes];
    
}

@end
