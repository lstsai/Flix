//
//  MovieCell.h
//  Flix
//
//  Created by laurentsai on 6/24/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (nonatomic, strong) Movie *movie;


@end

NS_ASSUME_NONNULL_END
