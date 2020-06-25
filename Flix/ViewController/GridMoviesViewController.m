//
//  GridMoviesViewController.m
//  Flix
//
//  Created by laurentsai on 6/24/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import "GridMoviesViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface GridMoviesViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredData;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation GridMoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;//since it is now inheriting the data and delegate
    self.searchBar.delegate=self;
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout= (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;//cast to supress warning
    layout.minimumInteritemSpacing=5;
    layout.minimumLineSpacing=5;
    
    CGFloat postersPerLine=3;
    CGFloat itemWidth=(self.collectionView.frame.size.width-layout.minimumInteritemSpacing*(postersPerLine-1)-10)/postersPerLine;//scale it to be the size you want per line,take into account interitem spacing and the margins of screen
    layout.itemSize=CGSizeMake(itemWidth, 1.5*itemWidth);
}
- (void) fetchMovies{
    [self.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/popular?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self.activityIndicator stopAnimating];
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
               // TODO: Get the array of movies
               self.movies= dataDictionary[@"results"];
               self.filteredData=self.movies;
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               [self.collectionView reloadData];//now you have data so have to reload self
           }
       }];
    [task resume];//actually start the task
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell=sender;//get which was tapped
    NSIndexPath *tappedIndex=[self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie= self.movies[tappedIndex.row];
    DetailsViewController *detailViewController= segue.destinationViewController;
    detailViewController.movie=movie;//set the tapped movie for the details controller to know whats up
    [self.searchBar endEditing:YES];//get rid of the keyboard
    [self.collectionView deselectItemAtIndexPath:tappedIndex animated:YES];//deselect/unhighlight


}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie= self.filteredData[indexPath.item];//all the movie title and pics
    NSString *baseURL= @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL= movie[@"poster_path"];
    NSString *fullURL=[baseURL stringByAppendingFormat:@"%@", posterURL];
    NSURL *fullposterURL = [NSURL URLWithString:fullURL];
    cell.posterView.image= nil;//make sure to clear so that when it is reused, the movie is not the old one
    [cell.posterView setImageWithURL:fullposterURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
        //NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.movies;
    }
    [self.collectionView reloadData];
 
}

@end
