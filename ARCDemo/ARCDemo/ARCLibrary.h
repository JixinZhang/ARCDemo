//
//  ARCLibrary.h
//  ARCDemo
//
//  Created by ZhangBob on 30/06/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCBook.h"

@interface ARCLibrary : NSObject

@property (nonatomic, copy) NSString *libraryName;
@property (nonatomic, strong) ARCBook *book;

@end
