//
//  CoreDataManager.m
//  CoreData
//
//  Created by 李超前 on 16/5/18.
//  Copyright © 2016年 李超前. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

#pragma mark - Core Data stack
/*
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
*/

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dvlproad.TestCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/**
 *  创建数据库存储位置
 *
 *  @return storeURL(coredataFileURL)
 */
+ (NSURL *)applicationStoreURL {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [documentDirectory stringByAppendingPathComponent:@"TestCoreData.sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    return storeURL;
}


/**
 *  创建管理对象模型
 *
 *  @return managedObjectModel
 */
+ (NSManagedObjectModel *)managedObjectModel {
    static NSManagedObjectModel *_managedObjectModel = nil;
    
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestCoreData" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //mergedModelFromBundles: 搜索工程中所有的.xcdatamodeld文件，并加载所有的实体到一个NSManagedObjectModel  实例中。这样托管对象模型知道所有当前工程中用到的托管对象的定义
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

/**
 *  创建持久化数据存储协调器
 *
 *  @return persistentStoreCoordinator
 */
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    static NSPersistentStoreCoordinator *_persistentStoreCoordinator = nil;
    
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestCoreData.sqlite"];
    NSURL *storeURL = [self applicationStoreURL];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

/**
 *  创建托管对象上下文(托管对象上下文类似于应用程序和数据存储之间的一块缓冲区。这块缓冲区包含所有未被写入数据存储的托管对象。你可以添加、删除、更改缓冲区内的托管对象。在很多时候，当你需要读、插入、删除对象时，你将会调用托管对象上下文的方法。)
 *
 *  @return managedObjectContext
 */
+ (NSManagedObjectContext *)managedObjectContext {
    static NSManagedObjectContext *_managedObjectContext = nil;
    
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

+ (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
