//
//  ViewController.m
//  SquareCrop
//
//  Created by Oliver Drobnik on 22.07.14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


UIImage *squareCropImageToSideLength(UIImage *sourceImage,
                                     CGFloat sideLength)
{
   // input size comes from image
   CGSize inputSize = sourceImage.size;
   
   // round up side length to avoid fractional output size
   sideLength = ceilf(sideLength);
   
   // output size has sideLength for both dimensions
   CGSize outputSize = CGSizeMake(sideLength, sideLength);
   
   // calculate scale so that smaller dimension fits sideLength
   CGFloat scale = MAX(sideLength / inputSize.width,
                       sideLength / inputSize.height);
   
   // scaling the image with this scale results in this output size
   CGSize scaledInputSize = CGSizeMake(inputSize.width * scale,
                                       inputSize.height * scale);
   
   // determine point in center of "canvas"
   CGPoint center = CGPointMake(outputSize.width/2.0,
                                outputSize.height/2.0);
   
   // calculate drawing rect relative to output Size
   CGRect outputRect = CGRectMake(center.x - scaledInputSize.width/2.0,
                                  center.y - scaledInputSize.height/2.0,
                                  scaledInputSize.width,
                                  scaledInputSize.height);
   
   // begin a new bitmap context, scale 0 takes display scale
   UIGraphicsBeginImageContextWithOptions(outputSize, YES, 0);
   
   // optional: set the interpolation quality.
   // For this you need to grab the underlying CGContext
   CGContextRef ctx = UIGraphicsGetCurrentContext();
   CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
   
   // draw the source image into the calculated rect
   [sourceImage drawInRect:outputRect];
   
   // create new image from bitmap context
   UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
   
   // clean up
   UIGraphicsEndImageContext();
   
   // pass back new image
   return outImage;
}


@implementation ViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   UIImage *image = [UIImage imageNamed:@"Image.jpg"];
   UIImage *squareImage = squareCropImageToSideLength(image, 300);
   self.imageView.image = squareImage;
}

@end
