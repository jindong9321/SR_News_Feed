//
//  UIViewController+NFSRTableView.m
//  NewsFeed_sugarain
//
//  Created by SBHR on 2015. 10. 3..
//  Copyright © 2015년 seungbin.baik. All rights reserved.
//

#import "NFSRTableViewController.h"
#import "NFSRDetailViewController.h"
#import "TFHpple.h"
#import "Tutorial.h"
#import "Contributor.h"
#import "NFRoginViewController.h"
#import "NFMainViewController.h"

@interface NFSRTableViewController () {
    NSMutableArray *_objects;
    NSMutableArray *_contributors;
}

@end

@implementation NFSRTableViewController

@synthesize detailViewController = _detailViewController;
@synthesize loginviewcontroller = _loginviewcontroller;
NSUInteger element_Count;

int rowNo;



//refresh
-(void)refreshView:(UIRefreshControl *)refresh {
    
    [self resetData];
    
    [refresh endRefreshing];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 40개가 안될시 뻑.........
    //NSLog(@" elementcount = > %lu",(unsigned long)[elements count]);
    return element_Count;
    
}

- (IBAction)SettingButton_Click:(id)sender {
    
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    [self.frostedViewController presentMenuViewController];

    
}

- (void)resetData
{
    
    NSURL *url = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/sns_do_login"];
    NSURL *url_1;
    ASIFormDataRequest *request;
    
    NSLog(@"table_url scheme => %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
    NSLog(@" link = > %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"]);
    if(([[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme" ] == nil) && ([[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"] == nil)  ){
        NSLog(@"\n\n 1 \n\n");
        url_1 = [NSURL URLWithString:@"http://www.sugarain.kr/login/accounts/do_login"];
        request = [ASIFormDataRequest requestWithURL:url_1];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveID"] forKey:@"userid"];
        [request setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"textPW"] forKey:@"passwd"];
        

    }else{
 NSLog(@"\n\n 2 \n\n");
        NSLog(@"url-scheme = > %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"url_scheme"]);
         request = [ASIFormDataRequest requestWithURL:url];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSLog(@" SNS_link = > %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_link"]);
        if( [[defaults objectForKey:@"SNS_link"] isEqualToString:@""]){
             NSLog(@"\n\n 3 \n\n");
            NSLog(@" \n\n google \n\n");
            [request setPostValue:@"google" forKey:@"sns"];
        }
        else{
            NSLog(@"\n\n 4 \n\n");
            NSLog(@"\n\nfacebook\n\n");
            [request setPostValue:@"facebook" forKey:@"sns"];


        }
        NSLog(@"\n\n 5 \n\n");
        NSLog(@" SNS_user_id => %@",[defaults objectForKey:@"SNS_user_id"]);
        NSLog(@" SNS_user_name => %@",[defaults objectForKey:@"SNS_user_name"]);
        NSLog(@" SNS_user_email => %@",[defaults objectForKey:@"SNS_user_email"]);
        NSLog(@" table => SNS_user_Token => %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"SNS_user_Token"]);
        
        [request setPostValue:[defaults objectForKey:@"SNS_user_id"]forKey:@"snsid"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_name"]forKey:@"name"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_email"] forKey:@"email"];
        [request setPostValue:[defaults objectForKey:@"SNS_user_Token"] forKey:@"token"];

        //[request setPostValue:@"https://graph.facebook.com/824671480985431/picture?type=large" forKey:@"picture"];
       
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
    NSString *stringFromURL = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://sugarain.kr/feeds"] encoding:NSUTF8StringEncoding error:&error];
    if(stringFromURL == nil)
    {
        NSLog(@"Error reading URL at %@\n%@", path, [error localizedFailureReason]);
        
    }
    NSString *stringFromURL2 = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://sugarain.kr/feeds/feed/index/page/2"] encoding:NSUTF8StringEncoding error:&error];
    if(stringFromURL == nil)
    {
        NSLog(@"Error reading URL at %@\n%@", path, [error localizedFailureReason]);
        
    }
    arrNewsList=[[NSMutableArray alloc] init];
    linkurl=[[NSMutableArray alloc] init];
    
    //[firstdata appendData:seconddata];
    NSData *data = [stringFromURL dataUsingEncoding:NSUnicodeStringEncoding];
    NSData *data2 = [stringFromURL2 dataUsingEncoding:NSUnicodeStringEncoding];
     Original_firstdata = [NSMutableData dataWithData:data];
    added_seconddata = [NSMutableData dataWithData:data2];
    [Original_firstdata appendData:added_seconddata];
    
    
    //Create parser // 저장
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:Original_firstdata];
    
    NSArray *elements=[xpathParser searchWithXPathQuery:XPATH_QUERY];
    element_Count = [elements count];
    
    for(int i=0;i<[elements count];i++)
    {
        NSLog(@"elements_count[%d], %@",i,[[elements objectAtIndex:i] content]);
        
        NSLog(@"2 %@", [[[elements objectAtIndex:i]attributes]valueForKey:@"href"]);
     
        TFHppleElement *element=[elements objectAtIndex:i] ;
        TFHppleElement *urls = [elements objectAtIndex:i];
        
        // 목록을 배열에 저장한다.
        [arrNewsList addObject:[element content]];
        
        noarrNewsList = [[NSMutableArray alloc] init];
        nameNewsList = [[NSMutableArray alloc] init];
        
        for(NSString *valuesDatum in arrNewsList) {
        removeNewLine  = [[valuesDatum componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            
            NSString *removeSpaceOne   = [removeNewLine stringByReplacingOccurrencesOfString:@" " withString:@" "];
            NSString *removeFirst             = [removeSpaceOne substringFromIndex:1];
            NSArray *chunks                      = [removeFirst componentsSeparatedByString: @"  "];
            NSArray *name                        = [removeFirst componentsSeparatedByString:@"  "];
            NSString* nameSplit                = [name objectAtIndex:1];
            NSString* currentOperation    = [chunks objectAtIndex:0];
            NSString *emptyList                = @"내용이 없습니다.^^;";
            if([currentOperation  isEqualToString: @""])
            {
                currentOperation  = [ currentOperation stringByAppendingString:emptyList];
                NSLog(@"current -> %@",currentOperation);
            }
            [nameNewsList addObject:nameSplit];
            [noarrNewsList addObject:currentOperation];

        }
 
        [linkurl addObject:[[urls attributes]valueForKey:@"href"]];
        NSLog(@"3 %@", noarrNewsList);
        NSLog(@"4 %@", linkurl);
    
        // 사용한 변수들을 메모리에서 제거.
        urls =nil;
        xpathParser=nil;
        element=nil;
        
        NSLog(@"\n\n ------------------------------------------------------------------------------------------- \n");
    }
      [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.title = @"";
    
    //refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@""];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    
    UIImage *image = [UIImage imageNamed: @"suga_logo_image.png"];
    UIImageView *imageView = [[[UIImageView alloc]  initWithFrame:CGRectMake(0,0,3,44)]initWithImage: image];
    self.navigationItem.titleView = imageView;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed: 77/255.0 green:182/255.0 blue:232/255.0 alpha:1.0];
    self.navigationController.navigationBarHidden = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"\ntablebiew_memeberid => %@", [defaults objectForKey:@"member_id"]);
    if ( [defaults objectForKey:@"member_id"] == nil ) {
        NSLog(@"No username found");
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"로그인 실패"
                                      message:@"로그인을 다시 시도해주시기 바랍니다."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NFRoginViewController *loginView =[self.storyboard instantiateViewControllerWithIdentifier:@"NFSRLoginViewController"];
                                 [loginView setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                                 [self presentViewController:loginView animated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     exit(0);
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    
    }
    else {
        
        [self resetData];
        
    }
}


//셀 설정
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *strCellReuseId=@"CELL_LIST";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellReuseId];
    
    
    
    //셀 초기화 부분 수정 => 데이터가 있음에도 초기화되는 현상 해결
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellReuseId];
    
    }
    if(indexPath.section == 0){
        cell.textLabel.text=[noarrNewsList objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [nameNewsList objectAtIndex:indexPath.row];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:(74/255.0) green:(151/255.0) blue:(229/255.0) alpha:1];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    urlStr = [linkurl objectAtIndex:indexPath.row];
    NSLog(@"\n\n  urlStr ->>>> %@\n\n", urlStr);

    BOOL prefix = [urlStr hasPrefix:@"http://www.sugarain.kr/"];
    if (!prefix)
    {
        urlStr2=[@"http://www.sugarain.kr/" stringByAppendingString: urlStr];
        
    }

    
    NSLog(@"%@",urlStr2);
    NSURL *url = [NSURL URLWithString:urlStr2];
    NSLog(@"\n\n  url ->>>> %@\n\n", url);

    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    NSLog(@"\n\n  requestURL ->>>> %@\n\n", requestURL);

    
    [[NSUserDefaults standardUserDefaults] setURL:url forKey:@"detail_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    [self.detailViewController.webView loadRequest:requestURL];
    if (!self.detailViewController) {
        NFSRDetailViewController *detailView =[self.storyboard instantiateViewControllerWithIdentifier:@"NFSRDetailViewController"];
        [self.navigationController pushViewController:detailView animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_setting_Button release];
    [_Setting_Button release];
    [super dealloc];
}
- (IBAction)setting_Button_Click:(id)sender {
    
    NFMainViewController *mainView =[self.storyboard instantiateViewControllerWithIdentifier:@"NFMainViewController"];
    [self.navigationController pushViewController:mainView animated:YES];

}
@end
