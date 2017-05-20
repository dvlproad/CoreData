//
//  Student+CoreDataProperties.h
//  CoreData
//
//  Created by 李超前 on 16/5/18.
//  Copyright © 2016年 李超前. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *studentNO;
@property (nullable, nonatomic, retain) NSNumber *gender;
@property (nullable, nonatomic, retain) NSString *age;

@end

NS_ASSUME_NONNULL_END
