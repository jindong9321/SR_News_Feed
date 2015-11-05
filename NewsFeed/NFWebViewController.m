//
//  NFWebViewController.m
//  NewsFeed
//
//  Created by RDMac on 2015. 9. 30..
//  Copyright (c) 2015년 RDmac. All rights reserved.
//

#import "NFWebViewController.h"

@interface NFWebViewController ()

@end

@implementation NFWebViewController
@synthesize  Webview;
@synthesize sugaImageView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

// 이벤트 등록 및 구현
\


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _WebTopview.backgroundColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:232/255.0 alpha:1.0];
    
   
    NSURL *NotiURL = [[NSURL alloc] initWithString:@"http://www.sugarain.kr/html/service.php"];    //NSURLRequest를 사용하려면 NSURL이 필요.
    NSURLRequest *urlRepqest = [[NSURLRequest alloc] initWithURL:NotiURL];                              //NSURLRequest를 생성하고 만들어 놓은 NSURL로 초기화
    
    [Webview loadRequest:urlRepqest];
    
    sugaImageView.image = [UIImage imageNamed:@"sugarain_logo.png"];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 뷰전환

- (IBAction)closeButton_Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)domainButton_Click:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"서비스 양해 공지"
                                                        message: @"이 웹사이트는 PC에 최적화되어있습니다.     사용이 원활하지 않을 수 있으니 PC에서 접속해주시기 바랍니다. "
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}



- (void)dealloc {
 
    [sugaImageView release];
      [super dealloc];
}




@end
