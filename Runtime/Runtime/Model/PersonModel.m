//
//  PersonModel.m
//  Runtime
//
//  Created by 阳光 on 17/1/11.
//  Copyright © 2017年 阳光. All rights reserved.
//

#import "PersonModel.h"
#import <objc/runtime.h>

// 归档解档需要遵循<NSCoding>协议
@interface PersonModel ()<NSCoding>

@end


@implementation PersonModel


// 利用遍历类的属性,来快速的进行归档操作
// 或将从网络上下载的json数据进行字典模型
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // 归档存储自定义对象
    unsigned int count=0;
    //获得指向当前类的所有属性的指针
    objc_property_t *properties=class_copyPropertyList([self class], &count);

    for (int i = 0; i < count; i++) {
        //获取指向当前类的一个属性的指针
        objc_property_t property = properties[i];
        //获取C字符串属性名
        const char *name = property_getName(property);
        //C字符串转OC字符串
        NSString *propertyName = [NSString stringWithUTF8String:name];
        //通过关键词取值
        NSString *propertyValue = [self valueForKey:propertyName];
        //编码属性,利用kvc取出每个属性对应的数值
        [aCoder encodeObject:propertyValue forKey:propertyName];
    }
    //记得释放
    free(properties);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
     // 归档存储自定义对象
    unsigned int count=0;
    //获得指向当前类的所有属性的指针
    objc_property_t *properties = class_copyPropertyList([self class], &count);

    for (int i = 0; i < count; i++) {
        //获取指向当前类的一个属性的指针
        objc_property_t property = properties[i];
        //获取C字符串属性名
        const char *name = property_getName(property);
        //C字符串转OC字符串
        NSString *propertyName = [NSString stringWithUTF8String:name];
        // 解码属性值
        NSString *propertyValue = [aDecoder decodeObjectForKey:propertyName];
        [self setValue:propertyValue forKey:propertyName];
    }
    //记得释放
    free(properties);
    return self;
}

-(void)eat
{

}

-(void)sleep
{

}

-(void)work
{

}

+(void)eat1
{
    
}
// 默认方法都有两个隐式参数，
void eat(id self,SEL sel)
{
    NSLog(@"%@ %@",self,NSStringFromSelector(sel));
}

// 当一个对象调用未实现的方法，会调用这个方法处理,并且会把对应的方法列表传过来.
// 刚好可以用来判断，未实现的方法是不是我们想要动态添加的方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(eat)) {
        // 动态添加eat方法

        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(self, @selector(eat),eat,"v@:");
    }
    return [super resolveInstanceMethod:sel];
}

@end
