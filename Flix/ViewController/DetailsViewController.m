//
//  DetailsViewController.m
//  Flix
//
//  Created by laurentsai on 6/24/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "RRViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopText;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *baseURL= @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL= self.movie[@"poster_path"];
    NSString *fullPosterURLString=[baseURL stringByAppendingFormat:@"%@", posterURL];
    NSURL *fullposterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:fullposterURL];//pic for the smaller
    
    NSString *backdropURL= self.movie[@"backdrop_path"];
    NSString *fullBackURLString=[baseURL stringByAppendingFormat:@"%@", backdropURL];
    NSURL *fullBackURL = [NSURL URLWithString:fullBackURLString];
    [self.backdropView setImageWithURL:fullBackURL];//bigger movie pic
    
    self.titleLabel.text=self.movie[@"title"];//change it to the selected movie info
    self.synopText.text=self.movie[@"overview"];
    
    NSString *releaseDate= @"Released: ";
    self.dateLabel.text= [releaseDate stringByAppendingString:self.movie[@"release_date"]];
    
    
    [self.synopText sizeToFit];
    [self.dateLabel sizeToFit];    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"trailerSegue"])
    {
        WebViewController *webVC= segue.destinationViewController;
        webVC.movie=self.movie;
    }
    else if([segue.identifier isEqualToString:@"rrSegue"])
    {
        RRViewController *rrVC=segue.destinationViewController;
        rrVC.movie=self.movie;
    }
    
}


@end
