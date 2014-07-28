/*
 * WAMasterViewController.h
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
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>

#define SCAN_NETWORKS_SEGMENT 0
#define STORED_NETWORKS_SEGMENT 1

@class WANetworkDetailsViewController;

@interface WAMasterViewController : UITableViewController

@property (strong, nonatomic) WANetworkDetailsViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewModeSelector;
- (IBAction)viewModeSelected;
- (IBAction)refreshNetworks;

@end
