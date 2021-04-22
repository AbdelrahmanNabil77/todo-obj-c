//
//  TodoItem.m
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import "TodoItem.h"

@implementation TodoItem
@synthesize title,desc,priority,status,createDate,reminderDate;
- (id)initWithCoder:(NSCoder *)coder{
//    self = [super init];
//    if (self != nil)
    if(self = [super init])
    {
        self.title = [coder decodeObjectForKey:@"title"];
        self.desc = [coder decodeObjectForKey:@"description"];
        self.priority = [coder decodeIntForKey:@"priority"];
        self.status = [coder decodeIntForKey:@"status"];
        self.createDate = [coder decodeObjectForKey:@"createDate"];
        self.reminderDate = [coder decodeObjectForKey:@"reminderDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
//    [super encodeWithCoder:coder];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.desc forKey:@"description"];
    [coder encodeInt:status forKey:@"status"];
    [coder encodeInt:priority forKey:@"priority"];
    [coder encodeObject:self.createDate forKey:@"createDate"];
    [coder encodeObject:self.reminderDate forKey:@"reminderDate"];
}
@end
