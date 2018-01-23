//
//  MessageForwarding.m
//  OC加强
//
//  Created by Aaron on 17/10/2017.
//  Copyright © 2017 Aaron. All rights reserved.
//

#import "MessageForwarding.h"

@implementation MessageForwarding

- (void)sendMessage {
    NSLog(@"message sent");
}

- (void)notExistMethod {
    NSLog(@"message forwarded.");
}

@end
