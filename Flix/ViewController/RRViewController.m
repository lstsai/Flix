//
//  RRViewController.m
//  Flix
//
//  Created by laurentsai on 6/26/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import "RRViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface RRViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *recMovies;
@property (weak, nonatomic) IBOutlet UILabel *noRecLabel;

@end

@implementation RRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.movieTitle.text=self.movie[@"title"];//change it to the selected movie info
    NSString *baseURL= @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL= self.movie[@"poster_path"];
    NSString *fullPosterURLString=[baseURL stringByAppendingFormat:@"%@", posterURL];
    NSURL *fullposterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:fullposterURL];//pic for the smaller
    
    [self setRating];
    [self fetchRecs];
}
-(void) setRating{
    double rate=[self.movie[@"popularity"] doubleValue];
    self.ratingLabel.text=[NSString stringWithFormat:@"%.2f %%",rate];
    if(rate>=95.0){
        self.wordRatingLabel.text=@"Excellent";
        self.wordRatingLabel.textColor=UIColor.greenColor;
    }
    else if(rate>=90.0){
        self.wordRatingLabel.text=@"Great";
        self.wordRatingLabel.textColor=UIColor.greenColor;
    }
    else if(rate>=80.0){
        self.wordRatingLabel.text=@"Good";
        self.wordRatingLabel.textColor=UIColor.greenColor;
    }
    else if(rate>=70.0){
        self.wordRatingLabel.text=@"Average";
        self.wordRatingLabel.textColor=UIColor.yellowColor;
    }
    else if(rate>=60.0){
        self.wordRatingLabel.text=@"Subpar";
        self.wordRatingLabel.textColor=UIColor.orangeColor;
    }
    else{
        self.wordRatingLabel.text=@"Bad";
        self.wordRatingLabel.textColor=UIColor.redColor;
    }
    
    int count= [self.movie[@"vote_count"] intValue];
    self.voteCountLabel.text=[NSString stringWithFormat:@"Out of %d votes", count];
    
}
-(void) fetchRecs{
    NSString *movieURL= [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/recommendations?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed",self.movie[@"id"]];

       NSURL *url = [NSURL URLWithString:movieURL];
       NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
       NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
       NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
                  NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                 // NSLog(@"%@", dataDictionary);
                  // TODO: Get the array of movies
                 
                  self.recMovies= dataDictionary[@"results"];
                  NSLog(@"%@", self.recMovies);
                  /*for(NSDictionary *movie in self.movies)
                  {
                      NSLog(@"%@", movie[@"title"]);
                      
                  }*/
                  // TODO: Store the movies in a property to use elsewhere
                  // TODO: Reload your table view data
                  if(self.recMovies.count==0)
                  {
                      self.noRecLabel.alpha=1;
                  }
                  else{
                      self.noRecLabel.alpha=0;
                  }
                  [self.tableView reloadData]; //call again bc movies might have changed
              }
          }];
       [task resume];//actually start the task
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell=sender;//get which was tapped
    NSIndexPath *tappedIndex=[self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie= self.recMovies[tappedIndex.row];
    DetailsViewController *detailViewController= segue.destinationViewController;
    detailViewController.movie=movie;//set the tapped movie for the details controller to know whats up
    [self.tableView deselectRowAtIndexPath:tappedIndex animated:YES];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCell *weakCell= [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];//use the cell that we created
        NSDictionary *movie= self.recMovies[indexPath.row];//all the movie titles
        weakCell.titleLabel.text=movie[@"title"];//change the title for each movie
        weakCell.synopLabel.text=movie[@"overview"];
        NSString *baseURL= @"https://image.tmdb.org/t/p/w500";
        NSString *posterURL= movie[@"poster_path"];
        NSString *fullURL=[baseURL stringByAppendingFormat:@"%@", posterURL];
        NSURL *fullposterURL = [NSURL URLWithString:fullURL];
        NSURLRequest *posterrequest=[NSURLRequest requestWithURL:fullposterURL];
        weakCell.posterView.image= nil;//make sure to clear so that when it is reused, the movie is not the old one
        [weakCell.posterView setImageWithURLRequest:posterrequest placeholderImage:nil
        success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
            
            // imageResponse will be nil if the image is cached
            if (imageResponse) {
                //NSLog(@"Image was NOT cached, fade in image");
                weakCell.posterView.alpha = 0.0;
                weakCell.posterView.image = image;
                weakCell.titleLabel.alpha=0.0;
                weakCell.synopLabel.alpha=0.0;
                
                //Animate UIImageView back to alpha 1 over 0.3sec
                [UIView animateWithDuration:0.3 animations:^{
                    weakCell.posterView.alpha = 1.0;
                    weakCell.titleLabel.alpha=1.0;
                    weakCell.synopLabel.alpha=1.0;
                }];
            }
            else {
                //NSLog(@"Image was cached so just update the image");
                weakCell.posterView.image = image;
            }
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
            //NSLog(@"Failed to load image");
    // do something for the failure condition
        }];
        
    //    cell.textLabel.text= movie[@"title"];//create a cell with movie title
        return weakCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recMovies.count;

}


@end
