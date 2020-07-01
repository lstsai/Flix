//
//  WebViewController.m
//  Flix
//
//  Created by laurentsai on 6/25/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *trailerView;
@property (strong, nonatomic) NSArray* movieResult;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString* movieURL= [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movieD[@"id"]];
        
        NSURL *url = [NSURL URLWithString:movieURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           // [self.activityIndicator stopAnimating];
               if (error != nil) {
                   NSLog(@"%@", [error localizedDescription]);
                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Networking Error"
                          message:@"There was an error loading the content"
                   preferredStyle:(UIAlertControllerStyleAlert)];
                   
                   UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                       //do nothing so when pressed, just dismiss
                   }];
                   [alert addAction:cancelAction];
                   
                   UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                       //do nothing, just dismiss
                   }];
                   [alert addAction:okAction];//add the action to the alert popup
                   [self presentViewController:alert animated:YES completion:^{
                       // nothing happens after show
                   }];
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];//get the movie video info
                   self.movieResult= dataDictionary[@"results"]; // get the important info
                   //NSLog(@"%@", self.movieResult);
                   
                   NSString *baseURL= @"https://www.youtube.com/watch?v=";
                   NSString *fullURL=[baseURL stringByAppendingString: self.movieResult[0][@"key"]];
                   
                   //NSLog(@"%@", fullURL);
                   NSURL *fullvidURL = [NSURL URLWithString:fullURL];
                   NSURLRequest *request=[NSURLRequest requestWithURL:fullvidURL];
                   [self.trailerView loadRequest:request];//load the trailer in the webview
                
                   [self.trailerView reload];//now you have data so have to reload self
               }
           }];
        [task resume];//actually start the task
    
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
