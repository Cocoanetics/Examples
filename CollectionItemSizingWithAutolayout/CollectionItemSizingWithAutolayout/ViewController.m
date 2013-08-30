//
//  ViewController.m
//  CustomCollectionViewLayout
//
//  Created by Oliver Drobnik on 30.08.13.
//  Copyright (c) 2013 Cocoanetics. All rights reserved.
//

#import "ViewController.h"
#import "TagCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation ViewController
{
	TagCollectionViewCell *_sizingCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UINib *cellNib = [UINib nibWithNibName:@"TagCollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"TagCell"];
	
	// get a cell as template for sizing
	_sizingCell = [[cellNib instantiateWithOwner:nil options:nil] objectAtIndex:0];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 100;
}

- (void)_configureCell:(TagCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row%2)
	{
		cell.label.text = @"A";
	}
	else if (indexPath.row%3)
	{
		cell.label.text = @"longer";
	}
	else 
	{
		cell.label.text = @"much longer";
	}
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
	
	[self _configureCell:cell forIndexPath:indexPath];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self _configureCell:_sizingCell forIndexPath:indexPath];
	
	return [_sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end
