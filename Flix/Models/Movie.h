//
//  Movies.h
//  Flix
//
//  Created by laurentsai on 7/1/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSURL *posterUrl;
@property (nonatomic, strong) NSURL *backdropUrl;
@property (nonatomic, strong) NSString *released;
- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;


@end

NS_ASSUME_NONNULL_END
