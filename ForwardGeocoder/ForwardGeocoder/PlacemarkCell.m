//
//  PlacemarkCell.m
//  ForwardGeocoder
//
//  Created by Oliver Drobnik on 16.05.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import "PlacemarkCell.h"

@implementation PlacemarkCell
{
   UILabel *_addressLabel;
}

- (void)layoutSubviews
{
   [super layoutSubviews];
   
   CGRect rect = CGRectInset(self.contentView.bounds, 15, 10);
   self.addressLabel.frame = rect;
}

- (void)prepareForReuse
{
   _addressLabel.attributedText = nil;
}

- (UILabel *)addressLabel
{
   if (!_addressLabel)
   {
      _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      _addressLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth
      | UIViewAutoresizingFlexibleHeight;
      _addressLabel.numberOfLines = 0;
      [self.contentView addSubview:_addressLabel];
   }
   
   return _addressLabel;
}

@end
