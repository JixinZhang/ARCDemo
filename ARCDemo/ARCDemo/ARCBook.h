//
//  ARCBook.h
//  ARCDemo
//
//  Created by ZhangBob on 30/06/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCBook : NSObject

@property (nonatomic, copy) NSString *bookTitle;    //书名
@property (nonatomic, copy) NSString *authorName;   //作者名
@property (nonatomic, assign) NSUInteger pages;     //页数

@end
