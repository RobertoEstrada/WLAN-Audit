/*
 * AdDelegate.m
 *
 * Copyright 2011 Roberto Estrada
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
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "AdDelegate.h"

@implementation AdDelegate

-(id)initWithViewController:(UITableViewController*)controller {
	if ((self = [super init])) {
		viewController = controller;
		[viewController retain];
	}
	return self;
}

-(void) dealloc {
    [viewController release];
    [super dealloc];	
}

#pragma mark -
#pragma mark GADBannerViewDelegate methods

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"AdMob: Ad received");
	viewController.tableView.tableHeaderView = (UIView*)bannerView;
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

@end
