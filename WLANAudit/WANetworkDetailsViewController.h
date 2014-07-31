/*
 * WANetworkDetailsViewController.h
 *
 * Copyright 2014 Roberto Estrada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 */

#import <UIScrollView+EmptyDataSet.h>
#import "QuickDialogController.h"

@class WANetworkData;

@interface WANetworkDetailsViewController : QuickDialogController<UISplitViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) WANetworkData *network;

- (IBAction)saveNetworkAsFavourite:(id)sender;

@end
