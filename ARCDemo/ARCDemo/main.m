//
//  main.m
//  ARCDemo
//
//  Created by ZhangBob on 30/06/2017.
//  Copyright © 2017 Jixin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCLibrary.h"

OBJC_EXTERN int _objc_rootRetainCount(id);

void arcDemo();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, world!");
        arcDemo();
    }
    return 0;
}

void printLog(NSObject *obj) {
    NSLog(@"%@'s ARC count = %d",[obj className] ,_objc_rootRetainCount(obj));
}

void arcDemo() {
    NSLog(@"ARC Demo Begin here ============");
    ARCLibrary *library = [[ARCLibrary alloc] init];

/*
 *  对象引用计数加1————retain操作：
 */
    //1.新创建   retainCount = 1
    __block ARCBook *book1 = [[ARCBook alloc] init];
    NSLog(@"Step1 book1's ARC count = %ld",CFGetRetainCount((__bridge CFTypeRef)(book1)));
    
    //2.赋值属性  retainCount = 2
    ARCBook *book2 = book1;
    NSLog(@"Step2 book1's ARC count = %d",_objc_rootRetainCount(book1));
    
    //3.赋值实例变量    retainCount = 3
    library.book = book1;
    NSLog(@"Step3 book1's ARC count = %d",_objc_rootRetainCount(book1));
    
    //4.传递给函数参数   retainCount = 4； 离开函数 retainCount = 3；
    printLog(book1);
    NSLog(@"Step4 book1's ARC count = %d",_objc_rootRetainCount(book1));
    
    //5.加入数组中   retainCount = 4
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:book1];
    NSLog(@"Step5 book1's ARC count = %d",_objc_rootRetainCount(book1));
    
/*
 * 对象引用计数减1————release操作；
 */
    
    //1.将对象从集合中删除 retainCount = 3
    [array removeObject:book1];
    NSLog(@"Step6 book1's ARC count = %d",_objc_rootRetainCount(book1));

    //2.属性赋值为nil retainCount = 2
    library.book = nil;
    NSLog(@"Step7 book1's ARC count = %d",_objc_rootRetainCount(book1));
    
    //3.属性赋值为nil retainCount = 1
    book2 = nil;
    NSLog(@"Step8 book1's ARC count = %d",_objc_rootRetainCount(book1));

    //4.属性赋值为nil retainCount = 0
    //如果把下面这行代码注释掉，则ARCBook的dealloc方法中打印的信息将会在”ARC demo finished here!“完成之后显示
//    book1 = nil;
    
    NSLog(@"ARC demo finished here!============");
}

/*
 *  ARC开启下获取引用计数的方法
 *
 *  1. 使用私有API OBJC_EXTERN int _objc_rootRetainCount(id)
 *
 *  1. 使用CFGetRetainCount CFGetRetainCount((__bridge CFTypeRef)(obj))
 */
