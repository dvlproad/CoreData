//
//  Home.m
//  CoreData
//
//  Created by 李超前 on 16/5/18.
//  Copyright © 2016年 李超前. All rights reserved.
//

#import "Home.h"
#import "CoreDataManager.h"
#import "Student.h"
#import "ContentViewController.h"

#define TABLE_NAME @"Student"

@interface Home ()

@property (nonatomic, weak) IBOutlet UITextField *textFieldStudentNo;
@property (nonatomic, weak) IBOutlet UITextField *textFieldName;
@property (nonatomic, weak) IBOutlet UITextField *textFieldAge;
@property (nonatomic, weak) IBOutlet UITextField *textFieldGender;

- (IBAction)add:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)viewdata:(id)sender;

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.managedObjectContext = [CoreDataManager managedObjectContext];
}

- (void)resetView {
    
}

- (IBAction)viewdata:(id)sender {
    ContentViewController *viewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    [self presentViewController:viewController animated:YES completion:^{
        ;
    }];
}


#pragma mark - 增
- (IBAction)add:(id)sender {
    if ([self.textFieldStudentNo.text isEqualToString:@""] ||
        [self.textFieldName.text isEqualToString:@""] ||
        [self.textFieldAge.text isEqualToString:@""] ||
        [self.textFieldGender.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Check it"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
    }
    [self add];
}

- (void)add {
    Student *student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:TABLE_NAME inManagedObjectContext:self.managedObjectContext];
    student.studentNO = self.textFieldStudentNo.text;
    student.name = self.textFieldName.text;
    student.age = self.textFieldAge.text;
    student.gender = [NSNumber numberWithInt:[self.textFieldGender.text intValue]];
    
    NSError *error = nil;
    if ([self.managedObjectContext save:&error]) {
        self.textFieldStudentNo.text = @"";
        self.textFieldName.text = @"";
        self.textFieldAge.text = @"";
        self.textFieldGender.text = @"";
    } else {
        [self showError:error forErrorType:@"add"];
    }
}

#pragma mark - 删除
- (IBAction)delete:(id)sender {
    [self deleteByStudentNO];
}

- (void)deleteByStudentNO {
    NSArray *searchResult = [self searchResult];
    __block Student *deletemp ;
    [searchResult enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.studentNO intValue] == [self.textFieldStudentNo.text intValue])
        {
            deletemp = obj;
            *stop = YES;
        }
    }];
    
    if (deletemp) {
        [self.managedObjectContext deleteObject:deletemp];
        NSLog(@"====ok===delete");
    }
}

#pragma mark - 查找
- (IBAction)search:(id)sender {
    [self searchResult];
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
        [self showError:error forErrorType:@"search"];
    }
    return result;
}

#pragma mark - 修改
- (IBAction)edit:(id)sender {
    NSArray *searchResult = [self searchResult];
    [searchResult enumerateObjectsUsingBlock:^(Student * obj, NSUInteger idx, BOOL *stop) {
        if ([obj.studentNO intValue] == [self.textFieldStudentNo.text intValue]) {
            obj.name = self.textFieldName.text;
            obj.gender = [NSNumber numberWithInt:[self.textFieldGender.text intValue]];
            obj.age = self.textFieldAge.text;
            
            NSError *error = nil;
            if ([self.managedObjectContext save:&error]) {
                ;
            } else {
                [self showError:error forErrorType:@"edit"];
            }
            *stop = YES;
        }
    }];
}

- (void)showError:(NSError *)error forErrorType:(NSString *)errorTypeString {
    NSString *errorMessage = [NSString stringWithFormat:@"%@ error = %@",errorTypeString, error];
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:errorMessage
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
    NSLog(@"%@", errorMessage);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textFieldStudentNo resignFirstResponder];
    [self.textFieldName resignFirstResponder];
    [self.textFieldGender resignFirstResponder];
    [self.textFieldAge resignFirstResponder];
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
