//
//  MovieCell.m
//  Flix
//
//  Created by laurentsai on 6/24/20.
//  Copyright © 2020 laurentsai. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setMovie:self.movie];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;

    self.titleLabel.text = self.movie.title;
    self.synopLabel.text = self.movie.overview;

    self.posterView.image = nil;
    if (self.movie.posterUrl != nil) {
        [self.posterView setImageWithURL:self.movie.posterUrl];
    }
    NSLog(@"Here in set movie");
}

@end
