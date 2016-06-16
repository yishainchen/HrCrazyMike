//
//  ViewController.m
//  HrCrazyMike
//
//  Created by B1media on 2016/6/6.
//  Copyright © 2016年 B1media. All rights reserved.
//

#import "ViewController.h"
#import <Crashlytics/Crashlytics.h>


@interface ViewController () <NSURLConnectionDelegate>
{
    NSURLConnection *_urlConnection;
    NSURLRequest *_request;
    BOOL _authenticated;
    UIActivityIndicatorView *indicator;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.delegate = self;
 
    NSURL *targetURL = [NSURL URLWithString:@"https://hr.crazymike.com.tw"];
    _request = [NSURLRequest requestWithURL:targetURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [self.webView loadRequest:_request]; //  self.webView替换成自己的webview

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    [connection start];
    
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = self.view.center;
        [self.view addSubview:indicator];
        [indicator bringSubviewToFront:self.view];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    
    if ([challenge previousFailureCount] == 0)
    {
        _authenticated = YES;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    } else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // remake a webview call now that authentication has passed ok.
    _authenticated = YES;
    [_urlConnection cancel];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];

}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
    [indicator startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Current URL = %@",webView.request.URL);
    [indicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //Check if the web view loadRequest is sending an error message
    NSLog(@"Error : %@",error);
    [indicator stopAnimating];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"無法連線" message:@"請確認是否已連結至公司wify" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self viewDidLoad];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reloadWebView:(id)sender {
    [self viewDidLoad];
    
}

@end
