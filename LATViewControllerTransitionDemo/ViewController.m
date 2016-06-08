//
//  ViewController.m
//  LATViewControllerTransitionDemo
//
//  Created by Later on 16/6/8.
//  Copyright © 2016年 Later. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)presentNewViewController:(id)sender {
    
    //init need set presentBlocks
    DetailViewController *detail = [[DetailViewController alloc] init];
    
    //present must be animated
    [self presentViewController:detail animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
