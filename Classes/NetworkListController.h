/*
 * NetworkListController.h
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

#import <UIKit/UIKit.h>

@interface NetworkListController : UITableViewController <UITableViewDelegate, UIAlertViewDelegate> {
	NSArray *wlanNetworks;
	NSArray *wlanBSSIDS;
	NSString *wlanKey;
}
- (void)scanForNetworks;
- (void)showAboutBox;

@property (nonatomic,retain) NSArray *wlanNetworks;
@property (nonatomic,retain) NSArray *wlanBSSIDS;
@property (nonatomic,retain) NSString *wlanKey;

@end
