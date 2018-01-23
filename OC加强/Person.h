//
//  Person.h
//  OC加强
//
//  Created by Aaron on 12/10/2017.
//  Copyright © 2017 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageForwarding.h"

@interface Person : NSObject<NSCoding>
{
    NSString * _name;
    int _age;
    
    @public
    NSString * _birth;
    
    @private
    NSString * _certificateID;
}

@property (nonatomic, copy) NSString * personID;

typedef struct PersonInfo {
    const char * personName;
    int age;
} * PersonInfo;

// * 声明一个实例方法
/// print the person name.
- (void)personName;

- (void)setName:(NSString *)name;
- (NSString *)name;

- (void)notExistMethod;

// * 声明一个实例方法，且不实现
- (void)dynamicMethod;
- (void)goTo: (NSString *)somePlace;

@end
