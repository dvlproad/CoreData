//
//  ViewController.m
//  CoreData
//
//  Created by 李超前 on 16/5/18.
//  Copyright © 2016年 李超前. All rights reserved.
//

#import "ViewController.h"
#import "Home.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)goCoreData:(id)sender {
    Home *viewController = [[Home alloc] initWithNibName:@"Home" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
