//
//  NFRootViewController.m
//  NewsFeed
//
//  Created by RDMac on 2015. 11. 20..
//  Copyright © 2015년 RDmac. All rights reserved.
//

#import "NFRootViewController.h"

@interface NFRootViewController ()

@end

@implementation NFRootViewController

-(void)awakeFromNib{
   
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationview"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFSettingViewController"];
    
}


//
//- (void)viewDidLoad {
//    
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    
//}


@end
