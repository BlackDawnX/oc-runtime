//
//  Person.m
//  OC加强
//
//  Created by Aaron on 12/10/2017.
//  Copyright © 2017 Aaron. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface Person()
{
    int _no;
}

// * 声明一个私有方法
- (void)clearName;

- (void)performSelectorWithRuntime;
- (void)performSelectorWithoutRuntime;

@end

// * 在这里以 C 语言的形式实现一个函数
void dynamicMethod() {
    NSLog(@"Here is a dynamic method.");
}

@implementation Person

// * 实例方法的实现
- (void)personName {
    if (_name != nil) {
        NSLog(@"Hello, my name is %@", _name);
    } else {
        NSLog(@"I don't have name!");
    }
}

- (void)clearName {
    _name = nil;
}

- (void)setName:(NSString *)name {
    _name = name;
}
- (NSString *)name {
    return _name;
}

// * 实现 NSCoder 协议以归档/解档
// 使用 Runtime 一次性将所有的变量归/解档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0;i < count;i++) {
        const char * name = ivar_getName(ivars[i]);
        NSString * ivarName = [[NSString alloc] initWithUTF8String:name];
        id value = [self valueForKey:ivarName];
        [aCoder setValue:value forKey:ivarName];
    }
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([self class], &count);
        
        for (int i = 0;i < count;i++) {
            const char * name = ivar_getName(ivars[i]);
            NSString * ivarName = [[NSString alloc] initWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:ivarName];
            [self setValue:value forKey:ivarName];
        }
    }
    return self;
}

- (void)performSelectorWithRuntime {
    Person * objc = self;
    for (int i = 0;i < 10000;i++) {
        objc_msgSend(objc, sel_registerName("getName"));
    }
}

- (void)performSelectorWithoutRuntime {
    for (int i = 0;i < 10000;i++) {
        [self name];
    }
}


// * 方法实现检测，在没有找到对应方法实现的时候会调用该方法，可以在该方法中创建具体的实现
// 程序崩溃前最后一次拯救机会
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // 将未实现的方法的实现（IMP）指针指向上方的 C 函数，作为方法的实现
    if (sel == @selector(dynamicMethod)) {
        class_addMethod([self class], sel, (IMP)dynamicMethod, "");
        return YES;
    }
    
    // 将未实现的方法的实现（IMP）指针指向 OC 方法
    if (sel == @selector(goTo:)) {
        class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(goToImplementation:)), "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

// 用于类方法的检测，用法和上方一致
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    
//}

- (void)goToImplementation: (NSString *)place {
    NSLog(@"%@ go to %@", _name, place);
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (strcmp(sel_getName(aSelector), "notExistMethod")) {
        NSLog(@"not exist method, it will be forwarded.");
        return [[MessageForwarding alloc] init];
    }
    return nil;
}

@end










