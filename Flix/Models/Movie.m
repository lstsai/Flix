//
//  Movies.m
//  Flix
//
//  Created by laurentsai on 7/1/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
self = [super init];

    self.title = dictionary[@"title"];
    self.overview= dictionary[@"overview"];
    NSString *baseURL= @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL= dictionary[@"poster_path"];
    NSString *fullURL=[baseURL stringByAppendingFormat:@"%@", posterURL];
    NSURL *fullposterURL = [NSURL URLWithString:fullURL];
    
    NSString *backdropURL= dictionary[@"backdrop_path"];
    NSString *fullBackURLString=[baseURL stringByAppendingFormat:@"%@", backdropURL];
    
    self.backdropUrl = [NSURL URLWithString:fullBackURLString];
    self.posterUrl=fullposterURL;
    NSString *releaseDate= @"Released: ";
    self.released = [releaseDate stringByAppendingString:dictionary[@"release_date"]];

    
// Set the other properties from the dictionary

return self;
}
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [NSMutableArray array];

   for( NSDictionary* dictionary in dictionaries)
   {
       Movie *curr = [[Movie alloc] initWithDictionary:dictionary];
       [movies addObject:curr];
   }
    return movies;
}
@end
