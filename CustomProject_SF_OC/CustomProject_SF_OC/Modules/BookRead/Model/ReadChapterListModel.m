//
//  ReadChapterListModel.m
//  CustomProject_SF_OC
//
//  Created by Land on 2019/1/11.
//  Copyright © 2019年 sfwen. All rights reserved.
//

#import "ReadChapterListModel.h"

@implementation ReadChapterListModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.priority = [aDecoder decodeIntegerForKey:@"priority"];
        self.bookID = [aDecoder decodeObjectForKey:@"bookID"];
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.priority forKey:@"priority"];
    [aCoder encodeObject:self.bookID forKey:@"bookID"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
