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
#import "Movie.h"
#import "MovieApiManager.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray *moviesArray;
@property (nonatomic, strong) NSMutableArray *filteredArray;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.searchBar.delegate=self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
    [self fetchMovies];//call the method to get the movies from api
    
    self.refreshControl= [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];//loading refresh and call movie fetch
    [self.tableView insertSubview:self.refreshControl atIndex:0];//move it behind the movies
}
- (void) fetchMovies{
    
    [self.activityIndicator startAnimating];//***start the activity indicator
    
    
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        self.movies = movies;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];//stop refresh load thing

    }];
    /*
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self.activityIndicator stopAnimating];//*** stop the indicator
        
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
              NSArray *dictionaries = dataDictionary[@"results"];
              for (NSDictionary *dictionary in dictionaries) {
                  Movie *movie = [[Movie alloc] initWithDictionary:dictionary];// Call the Movie initializer here

                  [self.moviesArray addObject:movie];
              }
               self.filteredArray= self.moviesArray;
               self.movies= dataDictionary[@"results"];
               //NSLog(@"%@", self.movies);
               self.filteredData=self.movies;
        */
    
               /*for(NSDictionary *movie in self.movies)
               {
                   NSLog(@"%@", movie[@"title"]);
                   
               }*/

               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               //[self.tableView reloadData]; //call again bc movies might have changed
           //}
        
        //[self.refreshControl endRefreshing];//stop refresh load thing
       //}];
    //[task resume];//actually start the task
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    MovieCell *weakCell= [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];//use the cell that we created
    Movie* currMovie= self.filteredArray[indexPath.row];
    
    weakCell.titleLabel.text=currMovie.title;//change the title for each movie
    weakCell.synopLabel.text=currMovie.overview;
    NSURLRequest *posterrequest=[NSURLRequest requestWithURL:currMovie.posterUrl];
    weakCell.posterView.image= nil;//make sure to clear so that when it is reused, the movie is not the old one
    [weakCell.posterView setImageWithURLRequest:posterrequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Image was NOT cached, fade in image");
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
            NSLog(@"Image was cached so just update the image");
            weakCell.posterView.image = image;
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        NSLog(@"Failed to load image");
// do something for the failure condition
    }];
    
//    cell.textLabel.text= movie[@"title"];//create a cell with movie title
    return weakCell;
    */

    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    cell.movie = self.movies[indexPath.row];
    
    return cell;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
        NSArray* arrayFiltered = [self.moviesArray filteredArrayUsingPredicate:predicate];
        self.filteredArray= [arrayFiltered mutableCopy];
        NSLog(@"%@", self.filteredArray);
        
    }
    else {
        self.filteredArray = self.moviesArray;
    }
    
    [self.tableView reloadData];
 
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell=sender;//get which was tapped
    NSIndexPath *tappedIndex=[self.tableView indexPathForCell:tappedCell];
    Movie *movie= self.filteredArray[tappedIndex.row];
    DetailsViewController *detailViewController= segue.destinationViewController;
    detailViewController.movie=movie;//set the tapped movie for the details controller to know whats up
    detailViewController.movieD=self.filteredData[tappedIndex.row];
    [self.searchBar endEditing:YES];
    [self.tableView deselectRowAtIndexPath:tappedIndex animated:YES];

}

@end
