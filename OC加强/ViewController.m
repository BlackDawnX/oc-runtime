//
//  ViewController.m
//  OC加强
//
//  Created by Aaron on 12/10/2017.
//  Copyright © 2017 Aaron. All rights reserved.
//

#import "ViewController.h"

// * 导入 Runtime 框架
#import <objc/runtime.h>
#import <objc/message.h>

// * 导入自定义头文件
#import "Person.h"

@interface ViewController ()

// * 私有方法声明
- (void)runtime;
- (void)archive;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // * 控制台输出调试字符
    // 字符串需要 Cocoa 类的 NSString，即加上 @ 符号
    NSLog(@"Hello, Objective-C!");
    
    // * Runtime
    [self runtime];
    
    // * 归/解档
    // 每一个类在进行归档前都要实现 NSCoding 中的协议方法
//    [self archive];
    
    //  Channel 5, Width 20MHz
    //https://github.com/brannondorsey/naive-hashcat
}

- (void)runtime {
    // * 实例化一个类
    Person * person = [[Person alloc] init];
    
    // * 向实例化的对象发送消息
    // 发送消息又叫 “调用方法”
    ((void (*) (id, SEL, NSString *)) objc_msgSend)(person, sel_registerName("setName:"), @"Aaron");
    ((void (*) (id, SEL)) objc_msgSend)(person, sel_registerName("personName"));
    // 上两段代码可以去掉强制转换
    objc_msgSend(person, sel_registerName("setName:"), @"Aaron");
    objc_msgSend(person, sel_registerName("personName"));
    // 非 Runtime 写法
    [person setName:@"Aaron without Runtime"];
    [person personName];
    
    // * 获取类的方法列表
    // 使用 Runtime 获取方法列表可以获取到私有方法
    unsigned int count = 0;
    Method * methodList = class_copyMethodList([Person class], &count);
    for (int i = 0;i < count;i++) {
        SEL selector = method_getName(methodList[i]);
        NSLog(@"%s", sel_getName(selector));
    }
    
    // * 获取类的属性列表
    // 使用 Runtime 获取属性列表可以获取到私有、被保护的成员属性
    unsigned int vcount = 0;
    Ivar * ivarList = class_copyIvarList([Person class], &vcount);
    for (int i = 0;i < vcount;i++) {
        const char * ivarName = ivar_getName(ivarList[i]);
        NSLog(@"%s", ivarName);
    }
    
    // * 利用选择器延迟调用方法
    double delayTime = 2;
    [person performSelector:sel_registerName("personName") withObject:NULL afterDelay:delayTime];
    
    // * 调用未被实现的方法
    // IMP 检测、动态解析 IMP 见 Person.m 文件
    [person dynamicMethod];
    [person goTo:@"School"];
}

- (void)archive {
    NSArray * pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [NSString stringWithFormat:@"%@/Person.archive", pathArr[0]];
    NSLog(@"%@", path);
    
    Person * person = [[Person alloc] init];
    person.personID = @"12345600";
    person.name = @"xhr";
    [NSKeyedArchiver archiveRootObject:person toFile:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
