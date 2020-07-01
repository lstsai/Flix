//
//  DetailsViewController.h
//  Flix
//
//  Created by laurentsai on 6/24/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Movie *movie;
@property (nonatomic, strong) NSDictionary *movieD;
@end

NS_ASSUME_NONNULL_END
