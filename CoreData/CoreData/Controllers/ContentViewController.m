//
//  ContentViewController.m
//  CoreData
//
//  Created by 李超前 on 16/5/18.
//  Copyright © 2016年 李超前. All rights reserved.
//

#import "ContentViewController.h"
#import "CoreDataManager.h"
#import "ContentCell.h"
#import "Student.h"

#define TABLE_NAME @"Student"

@interface ContentViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.managedObjectContext = [CoreDataManager managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *desption = [NSEntityDescription entityForName:TABLE_NAME inManagedObjectContext:self.managedObjectContext];
    [request setEntity:desption];
    
    NSSortDescriptor *desciptor = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:desciptor, nil]];
    
    //在CoreData为UITableView提供数据的时候，使用NSFetchedReslutsController能提高体验，因为用NSFetchedReslutsController去读数据的话，能最大效率的读取数据库，也方便数据变化后更新界面，
    //当我们设置好这个fetch的缓冲值的时候，我们就完成了创建 NSFetchedRequestController 并且将它传递给了fetch请求，但是这个方法其实还有以下几个参数：
    // 对于managed object 内容，我们值传递内容。
    //sectionnamekeypath允许我们按照某种属性来分组排列数据内容。
    //文件名的缓存名字应该被用来处理任何重复的任务，比如说设置分组或者排列数据等。
    NSFetchedResultsController *resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    resultController.delegate = self;
    self.fetchedResultsController = resultController;
    NSError * error = nil;
    
    //操作我们的 fetchedResultsController 并且执行performFetch 方法来取得缓冲的第一批数据。
    if ([self.fetchedResultsController performFetch:&error]) {
        NSLog(@"success");
        // NSLog(@"=======%@",[self.fetchedResultsController])
    } else {
        NSLog(@"error = %@",error);
    }
}

- (NSArray *)searchResult {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *desption = [NSEntityDescription entityForName:TABLE_NAME inManagedObjectContext:self.managedObjectContext];
    [request setEntity:desption];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (!error) {
        [result enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
            NSLog(@"--%ld,%@,%@,%@,%@--/n",idx,obj.studentNO,obj.name,obj.age,obj.gender);
        }];
    } else {
        NSLog(@"error seach  = %@",error);
    }
    return result;
}


- (IBAction)delete:(id)sender {
    NSArray * arr = [self searchResult];
    __block Student * deletemp ;
    [arr enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.studentNO intValue] == 2)
        {
            deletemp = obj;
            *stop = YES;
        }
    }];
    if (deletemp)
    {
        [self.managedObjectContext deleteObject:deletemp];
        NSLog(@"====ok===delete");
    }
}

//当数据发生变化时，点对点的更新tableview，这样大大的提高了更新效率
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            ContentCell * cell1 = (ContentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            Student * stu = (Student *)[controller objectAtIndexPath:indexPath];
            [cell1 showModel:stu];
        }
            break;
            
        default:
            break;
    }
}

//点对点的更新section
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeMove: {
            
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            
            break;
        }
    }
}

//此方法执行时，说明数据已经发生了变化，通知tableview开始更新UI
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

//结束更新
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
//- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName
//{
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //section配置
    // return [[self.fetchedResultsController sections] count];
    
    //row配置
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"markIdentifer";
    ContentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    Student *student = (Student *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell showModel:student];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
