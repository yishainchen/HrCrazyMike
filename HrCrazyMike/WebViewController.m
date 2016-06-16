//
//  WebViewController.m
//  HrCrazyMike
//
//  Created by B1media on 2016/6/13.
//  Copyright © 2016年 B1media. All rights reserved.
//

#import "WebViewController.h"
#import <AddressBook/Addressbook.h>

@interface WebViewController ()
{
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL _authenticated;
    UIActivityIndicatorView *indicator;
    
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    https://crazymike.tw/widget.asp?xml=y&site=facebook2&channel=5&page=1
    // Do any additional setup after loading the view.
    
    self.testWebView.delegate = self;
    
    NSURL *targetURL = [NSURL URLWithString:@"https://crazymike.tw/widget.asp?xml=y&site=facebook2&channel=5&page=1"];
    _request = [NSURLRequest requestWithURL:targetURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.testWebView loadRequest:_request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Current URL = %@",webView.request.URL);
  
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //Check if the web view loadRequest is sending an error message
    NSLog(@"Error : %@",error);
 
    
}
@end
