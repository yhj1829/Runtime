//
//  NSObject+Category.m
//  Runtime
//
//  Created by 阳光 on 17/1/11.
//  Copyright © 2017年 阳光. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>

@implementation NSObject (Category)

+(instancetype)modelWithDict:(NSDictionary *)dict
{
    id obj=[self new];
    // 遍历属性数组
    for (NSString *property in [self propertyList]) {
        // 判断字典中是否包含这个key
        if (dict[property]) {
            // 使用kvc赋值
            [obj setValue:dict[property] forKey:property];
        }
    }
    return obj;
}

+(NSArray *)propertyList
{
    unsigned int count=0;
    //获取模型属性, 返回值是所有属性的数组 objc_property_t
    objc_property_t *propertyList=class_copyPropertyList([self class],&count);
    NSMutableArray *arr=[NSMutableArray array];
    // 遍历数组
    for (int i=0;i<count;i++) {
        // 获取属性
        objc_property_t property=propertyList[i];
        //获取属性名称
        const char *cName = property_getName(property);
        NSString *name = [[NSString alloc]initWithUTF8String:cName];
        //添加到数组中
        [arr addObject:name];
    }
    //释放属性组
    free(propertyList);
    return arr.copy;
}

@end
