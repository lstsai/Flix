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
    
    [self.posterView setImageWithURL:self.movie.posterUrl];//pic for the smaller
    
    [self.backdropView setImageWithURL:self.movie.backdropUrl];//bigger movie pic
    
    self.titleLabel.text=self.movie.title;//change it to the selected movie info
    self.synopText.text=self.movie.overview;
    
    self.dateLabel.text= self.movie.released;
    
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
        webVC.movieD=self.movieD;
    }
    else if([segue.identifier isEqualToString:@"rrSegue"])
    {
        RRViewController *rrVC=segue.destinationViewController;
        rrVC.movie=self.movieD;
    }
    
}


@end
