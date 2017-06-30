#iOS ARC(代码演示引用计数的变化)

### 1.了解ARC
* 自动引用计数(Automatic Refrence Counting)是Objective-C默认的内存管理机制，其针对堆上的对象，由编译器自动生成操作引用计数的指令（retain或者release），来管理对象的创建与释放。
* 哪些对象受ARC管理：
	* OC对象指针；
	* Block指针；
	* 使用__attribute__((NSObject)) 定义的typedef
* 哪些对象不受ARC管理：
	* 值类型（简单值类型，C语言struct）；
	* 使用其它方式分配的堆对象（如使用malloc分配方式）；
	* 非内存资源。

### 2.引用计数管理
* 新创建(使用alloc，new，copy等)一个引用类型对象，引用计数为1；
* 对象引用计数加1————retain操作：
	* 将对象引用赋值给其他变量或者常量；
	* 将对象引用赋值给其他属性或者实例变量；
	* 将对象传递给函数参数，或者返回值；
	* 将对象加入集合中；

* 对象引用计数减1————release操作；
	* 将局部变量或者全局变量赋值为nil或者其他值；
	* 将属性赋值为nil或者其他值；
	* 实例属性所在对象被释放；
	* 参数或者局部变量离开函数；
	* 将对象从集合中删除

* 引用计数变为0时，内存自动被释放

###3.代码演示
1）main.m文件

```
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
    book1 = nil;
    
    NSLog(@"ARC demo finished here!============");
}

```
2）控制台打印的信息

![ARC Demo1.png](http://upload-images.jianshu.io/upload_images/2409226-3b49a280644619f9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![ARC Demo2.png](http://upload-images.jianshu.io/upload_images/2409226-0b177f3b6f74b675.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
