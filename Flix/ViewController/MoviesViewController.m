//
//  MoviesViewController.m
//  Flix
//
//  Created by laurentsai on 6/24/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIRefreshControl *refreshControl;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    // Do any additional setup after loading the view.
    [self fetchMovies];//call the method to get the movies from api
    self.refreshControl= [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];//loading refresh and call movie fetch
    [self.tableView insertSubview:self.refreshControl atIndex:0];//move it behind the movies
}
- (void) fetchMovies{
    NSLog(@"Triggered");
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
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
               //NSLog(@"%@", dataDictionary);
               // TODO: Get the array of movies
              
               self.movies= dataDictionary[@"results"];
               /*for(NSDictionary *movie in self.movies)
               {
                   NSLog(@"%@", movie[@"title"]);
                   
               }*/
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.tableView reloadData]; //call again bc movies might have changed
           }
        [self.refreshControl endRefreshing];//stop refresh load thing
       }];
    [task resume];//actually start the task
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movies.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell= [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];//use the cell that we created
    NSDictionary *movie= self.movies[indexPath.row];//all the movie titles
    cell.titleLabel.text=movie[@"title"];//change the title for each movie
    cell.synopLabel.text=movie[@"overview"];
    NSString *baseURL= @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL= movie[@"poster_path"];
    NSString *fullURL=[baseURL stringByAppendingFormat:@"%@", posterURL];
    NSURL *fullposterURL = [NSURL URLWithString:fullURL];
    cell.posterView.image= nil;//make sure to clear so that when it is reused, the movie is not the old one
    [cell.posterView setImageWithURL:fullposterURL];
    
//    cell.textLabel.text= movie[@"title"];//create a cell with movie title
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell=sender;//get which was tapped
    NSIndexPath *tappedIndex=[self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie= self.movies[tappedIndex.row];
    DetailsViewController *detailViewController= [segue destinationViewController];
    detailViewController.movie=movie;//set the tapped movie for the details controller to know whats up
    NSLog(@"Leaving");
}

@end
