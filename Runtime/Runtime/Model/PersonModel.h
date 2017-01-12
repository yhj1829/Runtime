//
//  PersonModel.h
//  Runtime
//
//  Created by 阳光 on 17/1/11.
//  Copyright © 2017年 阳光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"

@protocol PersonModelDelegate <NSObject>

-(void)goToWork;

@end


@interface PersonModel : NSObject

@property(nonatomic,assign)id<PersonModelDelegate>delegate;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,assign)int age;

@property(nonatomic,assign)float height;

+(void)eat1;

-(void)eat;

-(void)sleep;

-(void)work;

@end
