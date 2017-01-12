//
//  ViewController.m
//  Runtime
//
//  Created by 阳光 on 17/1/11.
//  Copyright © 2017年 阳光. All rights reserved.
//  发送消息/交换方法/动态的添加方法/分类添加属性/字典转模型

#import "ViewController.h"
#import "PersonModel.h"
#import <objc/runtime.h>
#import "NSMutableArray+Extension.h"
#import "NSObject+Property.h"
#import <objc/message.h>

@interface ViewController ()<PersonModelDelegate>

@property(nonatomic,strong)NSMutableArray *arrM;

@end

@implementation ViewController

/*
 1.什么是runtime?

 runtime是一套底层的C语言API，包含很多强大实用的C语言数据类型和C语言函数，平时我们编写的OC代码，底层都是基于runtime实现的。


 2.runtime有什么作用？

 可以动态产生(修改,删除)一个类,一个成员变量,一个方法


 3.常用的头文件

 #import <objc/runtime.h> 包含对类、成员变量、属性、方法的操作
 #import <objc/message.h> 包含消息机制
 

 4.常用方法

 class_copyIvarList（）返回一个指向类的成员变量数组的指针
 class_copyPropertyList（）返回一个指向类的属性数组的指针
 注意：根据Apple官方runtime.h文档所示，上面两个方法返回的指针，在使用完毕之后必须free()。

 ivar_getName（）获取成员变量名-->C类型的字符串
 property_getName（）获取属性名-->C类型的字符串

 -------------------------------------
 typedef struct objc_method *Method;
 class_getInstanceMethod（）
 class_getClassMethod（）以上两个函数传入返回Method类型
 ---------------------------------------------------

 method_exchangeImplementations（）交换两个方法的实现
 

 5.runtime在开发中的用途

 1.动态的遍历一个类的所有成员变量,用于字典转模型,归档解档操作
 代码如下：
 - (void)viewDidLoad 
 {
 [super viewDidLoad];

 // 利用runtime遍历一个类的全部成员变量
 1.导入头文件<objc/runtime.h>

 unsigned int count = 0;
 //  Ivar:表示成员变量类型
  Ivar *ivars = class_copyIvarList([PersonModel class], &count);获得一个指向该类成员变量的指针
   for (int i =0; i < count; i ++) {
    // 获得Ivar
    Ivar ivar = ivars[i];        
  // 根据ivar获得其成员变量的名称--->C语言的字符串
    const char *name = ivar_getName(ivar);
    NSString *key = [NSString stringWithUTF8String:name];
    NSLog(@"%d----%@",i,key);
  }
 
 // 获取一个类的全部属性
    [self test2];
}

*/


-(void)goToWork
{

}
// 交换方法
// 通过runtime的method_exchangeImplementations(Method m1, Method m2)方法，可以进行交换方法的实现；一般用自己写的方法（常用在自己写的框架中，添加某些防错措施）来替换系统的方法实现，常用的地方有：

// 在数组中，越界访问程序会崩，可以用自己的方法添加判断防止程序出现崩溃数组或字典中不能添加nil，如果添加程序会崩，用自己的方法替换系统防止系统崩溃
-(void)changeMethodTest
{

    [self.arrM addObject:@"电视剧"];

    [self.arrM addObject:@"综艺"];

    // 如果向数组中添加了nil程序会崩溃
    // 但是在NSMutableArray+Extension里添加了交换方法 此时再运行则不会崩溃
    [self.arrM addObject:nil];

    NSLog(@"交换方法:%@",self.arrM);

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _arrM=[NSMutableArray array];


    self.title=@"Runtime";

    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,100,[UIScreen mainScreen].bounds.size.width-20,300)];
    titleLabel.text=@" 1.归档与解档\n 2.获取一个类的全部成员变量名\n 3.获取一个类的全部属性名\n 4.获取一个类的全部方法\n 5.获取一个类遵循的全部协议\n 6.给分类添加属性\n 7.动态添加方法\n 8.交换方法\n 9.消息机制\n 10.字典转模型";
    titleLabel.numberOfLines=0;
    titleLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:titleLabel];


      // 归档与解档
//    [self test];

    // 获取一个类的全部成员变量名
//    [self test1];

    // 获取一个类的全部属性名
//    [self test2];

    // 获取一个类的全部方法
//    [self test3];

    // 获取一个类遵循的全部协议
//    [self test4];

    // 给分类添加属性
//    [self addProperty];

    // 动态添加方法
//    [self addMethod];

    // 交换方法
//    [self changeMethodTest];

//    [self changeMethodTest1];

    // 消息机制
    [self messageTest];

    // 字典转模型
//    [self model];
}

// 字典转模型
-(void)model
{
    NSDictionary *dic=@{
                        @"name":@"Sunshine",
                        @"sex":@"女"
                        };
    PersonModel *personModel=[PersonModel modelWithDict:dic];
    NSLog(@"name---%@\n sex--%@",personModel.name,personModel.sex);

}


// 消息机制
// objc_msgSend,只有对象才能发送消息,因此以objc开头.
// 使用消息机制的前提:导入#improt<objc/message.h>
-(void)messageTest
{
  // 创建personModel对象
    PersonModel *personModel=[PersonModel new];

    // 调用对象方法
    [personModel eat];

    // 本质:让对象发送消息
//    ((void (*) (id,SEL))(void *)objc_msgSend)(personModel,@selector(eat));


    // 调用类方法的方式：两种
    // 第一种通过类名调用
    [PersonModel eat1];
    // 第二种通过类对象调用
    [[PersonModel class] eat1];

    
    // 用类名调用类方法，底层会自动把类名转换成类对象调用
    // 本质：让类对象发送消息
//    ((void (*) (id,SEL))(void *)objc_msgSend)([PersonModel class],@selector(eat));
}


// 交换方法
// 开发场景:系统自带的方法功能不够,给系统自带的方法扩展一些功能.并且保留原有的功能.
// 方式1:继承系统的类,重写方法.
// 方式2:使用runtime,交换方法.
-(void)changeMethodTest1
{
    // 需求：给imageNamed方法提供功能，每次加载图片就判断下图片是否加载成功。
    // 步骤一：先搞个分类，定义一个能加载图片并且能打印的方法+ (instancetype)imageWithName:(NSString *)name;
    // 步骤二：交换imageNamed和imageWithName的实现，就能调用imageWithName，间接调用imageWithName的实现。
    UIImage *image = [UIImage imageNamed:@"123"];
    NSLog(@"图片为:----%@",image);
}


// 动态添加方法
// 开发场景:如果一个类方法非常多,加载了到内存的时候也比较耗费资源,需给每个方法生成映射表,可以使用动态给某个类,添加方法解决.
// 经典面试题:有没有使用preformSelector,其实主要想问有没有添加过方法;
-(void)addMethod
{
    PersonModel *p = [[PersonModel alloc] init];

    // 默认person，没有实现eat方法，可以通过performSelector调用，但是会报错。
    // 动态添加方法就不会报错
    [p performSelector:@selector(eat)];
}

// 给分类添加属性
// 原理:给一个类声明属性,其实本质就是给这个类添加关联,并不是直接把这个值的内存空间添加到类上.
-(void)addProperty
{
  // 给系统NSObject类动态添加属性name
    NSObject *object=[NSObject new];
    object.name=@"Sunshine";
    NSLog(@"添加属性－－－%@",object.name);
    // 添加属性－－－Sunshine
}


// 获取一个类遵循的全部协议
- (void)test4 {
    unsigned int count;

    //获取指向该类遵循的所有协议的指针
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([self class], &count);

    for (int i = 0; i < count; i++) {
        //获取该类遵循的一个协议指针
        Protocol *protocol = protocols[i];
        //获取C字符串协议名
        const char *name = protocol_getName(protocol);
        //C字符串转OC字符串
        NSString *protocolName = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,protocolName);
    }
    //记得释放
    free(protocols);
}


// 获取一个类的全部方法
- (void)test3 {
    unsigned int count;
    //获取指向该类所有方法的指针
    Method *methods = class_copyMethodList([PersonModel class], &count);

    for (int i = 0; i < count; i++) {
        //获取该类的一个方法的指针
        Method method = methods[i];
        //获取方法
        SEL methodSEL = method_getName(method);
        //将方法转换为C字符串
        const char *name = sel_getName(methodSEL);
        //将C字符串转为OC字符串
        NSString *methodName = [NSString stringWithUTF8String:name];

        //获取方法参数个数
        int arguments = method_getNumberOfArguments(method);

        NSLog(@"%d == %@ %d",i,methodName,arguments);
    }
    //记得释放
    free(methods);
}


// 利用runtime遍历获取一个类的全部属性名
- (void)test2
{
    unsigned int count;

    //获得指向该类所有属性的指针
    objc_property_t *properties =class_copyPropertyList([PersonModel class], &count);

    for (int i = 0; i < count; i++) {
        //获得该类的一个属性的指针
        objc_property_t property = properties[i];
        //根据 objc_property_t获取其属性的名称－－>C语言的字符串
        const char *name = property_getName(property);
        //将C的字符串转为OC的
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    //记得释放
    free(properties);
}


// 获取一个类的全部成员变量名
- (void)test1
{
    unsigned int count;

    // 获取成员变量的结构体
    Ivar *ivars = class_copyIvarList([PersonModel class],&count);

    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        //根据ivar获得其成员变量的名称
        const char *name = ivar_getName(ivar);
        //C的字符串转OC的字符串
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    //记得释放
    free(ivars);
}


// 归档与解档
-(void)test
{
    PersonModel *personModel=[PersonModel new];
    personModel.name=@"Sunshine";
    personModel.sex=@"man";
    personModel.age=20;
    personModel.height=163;

    // 归档
    NSString *path=[NSString stringWithFormat:@"%@/archive",NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject:personModel toFile:path];

    // 解档
    PersonModel *person=[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"归档－－－%@\n解档－－－%@",path,person);
    /*
     归档－－－/Users/yangguang/Library/Developer/CoreSimulator/Devices/2CA71453-01F7-4595-B52E-CDB245E51D48/data/Containers/Data/Application/C5EF340B-9479-41CA-8946-DA97231EA830/archive
     解档－－－<PersonModel: 0x7cc8b410>
     */
}


@end
