//
//  CoreDataManager.h
//  CoreData
//
//  Created by 李超前 on 16/5/18.
//  Copyright © 2016年 李超前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

/*
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
*/


/**
*  创建托管对象上下文(托管对象上下文类似于应用程序和数据存储之间的一块缓冲区。这块缓冲区包含所有未被写入数据存储的托管对象。你可以添加、删除、更改缓冲区内的托管对象。在很多时候，当你需要读、插入、删除对象时，你将会调用托管对象上下文的方法。)
*
*  @return managedObjectContext
*/
+ (NSManagedObjectContext *)managedObjectContext;

+ (void)saveContext;

@end
