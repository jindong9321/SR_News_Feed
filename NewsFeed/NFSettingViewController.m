//
//  NFSettingViewController.m
//  NewsFeed
//
//  Created by RDMac on 2015. 11. 20..
//  Copyright © 2015년 RDmac. All rights reserved.
//
#import <UIKit/UIStringDrawing.h>
#import "TFHpple.h"
#import "Tutorial.h"
#import "Contributor.h"
#import "QuartzCore/QuartzCore.h"

#import "NFSettingViewController.h"
#import "NFSRTableViewController.h"
#import "NFNavigationController.h"
#import "UIViewController+REFrostedViewController.h"

@interface NFSettingViewController ()

@end

@implementation NFSettingViewController


//NSUserDefaults Load
+ (id) loadFromUserDefaults:(id) key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id val = nil;
    if (userDefaults && key) {
        val = [userDefaults objectForKey:key];
    }
    return val;
}

- (void)load_img
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/sns_do_login"];
    NSURL *url_1;
    ASIFormDataRequest *request;
    
    NSLog(@"table_url scheme => %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
    NSLog(@" link = > %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"]);
    if(([[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme" ] == nil) && ([[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"] == nil)  ){
        url_1 = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/do_login"];
        request = [ASIFormDataRequest requestWithURL:url_1];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveID"] forKey:@"userid"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"textPW"] forKey:@"passwd"];
        
        
    }else{
        
        NSLog(@"url-scheme = > %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
        request = [ASIFormDataRequest requestWithURL:url];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@" SNS_link = > %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"]);
        if( [[defaults objectForKey:@"SNS_link"] isEqualToString:@""] /*&&([defaults objectForKey:@"SNS_link"] == nil)*/){
            NSLog(@" \n\n google \n\n");
            [request setPostValue:@"google" forKey:@"sns"];
        }
        else{
            NSLog(@"\n\nfacebook\n\n");
            [request setPostValue:@"facebook" forKey:@"sns"];
            
            
        }
        
        NSLog(@" SNS_user_id => %@",[defaults objectForKey:@"SNS_user_id"]);
        NSLog(@" SNS_user_name => %@",[defaults objectForKey:@"SNS_user_name"]);
        NSLog(@" SNS_user_email => %@",[defaults objectForKey:@"SNS_user_email"]);
        [request setPostValue:[defaults objectForKey:@"SNS_user_id"]forKey:@"snsid"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_name"]forKey:@"name"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_email"] forKey:@"email"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_Token"] forKey:@"token"];
        
        //        [request setPostValue:@"https://graph.facebook.com/824671480985431/picture?type=large" forKey:@"picture"];
        [request setResponseEncoding:NSUTF8StringEncoding];
        
    }
    
    [request setDelegate:self];
    [request startSynchronous];
    [request setCompletionBlock:^{
        [request responseString];
        
    }];
    [request setFailedBlock:^{
        
    }];
    
    NSString *path=@"";
    NSError *error;
    NSString *stringFromURL = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://sugarain.kr/dashboard"] encoding:NSUTF8StringEncoding error:&error];
    if(stringFromURL == nil)
    {
        NSLog(@"Error reading URL at %@\n%@", path, [error localizedFailureReason]);
        
    }
    
    NSData *data = [stringFromURL dataUsingEncoding:NSUnicodeStringEncoding];
    
    //Create parser // 저장
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements=[xpathParser searchWithXPathQuery:XPATH_QUERY2];
    
    for(int i=0;i<[elements count];i++)
    {
        
        NSLog(@"elements_count[%d], %@",i,[[elements objectAtIndex:i] content]);
        
        NSLog(@"2 %@", [[[elements objectAtIndex:i]attributes]valueForKey:@"pagespeed_lazy_src"]);
        
        urlneed = [[[elements objectAtIndex:i]attributes]valueForKey:@"pagespeed_lazy_src"];
        
        if(urlneed==nil){
            urlneed = [[[elements objectAtIndex:i]attributes]valueForKey:@"src"];
        }
        else {
            urlneed = [[[elements objectAtIndex:i]attributes]valueForKey:@"pagespeed_lazy_src"];
        }
        
        xpathParser = nil;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    [self load_img];
    
    NSLog (@"\n\n 5 %@", urlneed);
    
    BOOL prefix = [urlneed hasPrefix:@"http://www.sugarain.kr/"];
    if (!prefix)
    {
        urlStr2=[@"http://www.sugarain.kr/" stringByAppendingString: urlneed];
        
    }
    
    
    NSLog(@"%@",urlStr2);
//    NSURL *url               = [NSURL URLWithString:urlStr2];
//    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
//    NSLog(@"%@", requestURL);
    
   UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr2]]];
     NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data1 writeToFile:pngFilePath atomically:YES];

    NSLog(@"\n\n pngFilepath = %@\n\n",pngFilePath);
    
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
       // imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.image = [UIImage imageNamed:pngFilePath];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_nameString"];
        label.text = username;
        [[NSUserDefaults standardUserDefaults] synchronize];

        label.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NFNavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationview"];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NFSRTableViewController *tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NFSRTableViewController"];
        navigationController.viewControllers = @[tableViewController];
    }
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Notification ", @"Notification Section"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"John Appleseed", @"John Doe", @"Test User"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
