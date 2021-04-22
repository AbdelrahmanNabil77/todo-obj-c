//
//  TodoItem.h
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoItem : NSObject<NSCoding>
@property NSString *title;
@property NSString *desc;
@property NSString *reminderDate;
@property NSString *createDate;
@property int priority;
@property int status;


@end

NS_ASSUME_NONNULL_END
