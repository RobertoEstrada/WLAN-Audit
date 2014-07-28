/*
 * WANetworkDetailsViewController.m
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

#import "WANetworkDetailsViewController.h"
#import "WANetworkData.h"

@interface WANetworkDetailsViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation WANetworkDetailsViewController

@synthesize network;

#pragma mark - Lifecycle

- (void)loadView
{
    [super setRoot:[self setupDialog]];
    [super loadView];
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (network != nil) {
        self.navigationItem.title = network.essid;
    }
}

#pragma mark - Actions

- (IBAction)saveNetworkAsFavourite:(id)sender
{
    
}

#pragma mark - Detail item

-(void)setNetwork:(WANetworkData *)selectedNetwork
{
    if (selectedNetwork != nil) {
        network = selectedNetwork;
        [self configureView];
    }
}

#pragma mark - Quickdialog

-(QRootElement*)setupDialog
{
    QRootElement *dialogRoot = [[QRootElement alloc] init];
    
    dialogRoot.grouped = YES;
    dialogRoot.controllerName = NSStringFromClass([WANetworkDetailsViewController class]);
    
    QSection *ssidSection = [[QSection alloc] initWithTitle:NSLocalizedString(@"NET_SSID_SECTION_LABEL", @"Network name")];
    QLabelElement *essidLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_ESSID_LABEL", @"ESSID") Value:nil];
    essidLabel.key = @"ESSID_LABEL";
    
    QLabelElement *bssidLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_BSSID_LABEL", @"BSSID") Value:nil];
    bssidLabel.key = @"BSSID_LABEL";
    
    [ssidSection addElement: essidLabel];
    [ssidSection addElement:bssidLabel];
    
    QSection *detailsSection = [[QSection alloc] initWithTitle:NSLocalizedString(@"NET_DETAILS_SECTION_LABEL", @"Details")];
    
    QLabelElement *channelLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_CHANNEL_LABEL", @"Channel") Value:nil];
    channelLabel.key = @"CHANNEL_LABEL";
    
    QLabelElement *modeLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_MODE_LABEL", @"Mode") Value:nil];
    modeLabel.key = @"MODE_LABEL";
    
    QLabelElement *rssiLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_RSSI_LABEL", @"RSSI") Value:nil];
    rssiLabel.key = @"RSSI_LABEL";
    
    QLabelElement *wepLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_WEP_LABEL", @"WEP") Value:nil];
    wepLabel.key = @"WEP_LABEL";
    
    QLabelElement *wpaLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_WPA_LABEL", @"WPA") Value:nil];
    wpaLabel.key = @"WPA_LABEL";
    
    [detailsSection addElement:channelLabel];
    [detailsSection addElement:modeLabel];
    [detailsSection addElement:rssiLabel];
    [detailsSection addElement:wepLabel];
    [detailsSection addElement:wpaLabel];
    
    [dialogRoot addSection:ssidSection];
    [dialogRoot addSection:detailsSection];
    
    return dialogRoot;
}

-(void)configureView
{
    if (network != nil) {
        ((QLabelElement*)[self.root elementWithKey:@"ESSID_LABEL"]).value = network.essid;
        ((QLabelElement*)[self.root elementWithKey:@"BSSID_LABEL"]).value = network.bssid;
        ((QLabelElement*)[self.root elementWithKey:@"CHANNEL_LABEL"]).value = [NSString stringWithFormat:@"%d",network.channel];
        ((QLabelElement*)[self.root elementWithKey:@"MODE_LABEL"]).value = network.mode;
        ((QLabelElement*)[self.root elementWithKey:@"RSSI_LABEL"]).value = network.rssi;
        ((QLabelElement*)[self.root elementWithKey:@"WEP_LABEL"]).value = network.wep ? NSLocalizedString(@"MSG_YES", @"YES"):NSLocalizedString(@"MSG_NO", @"NO");
        ((QLabelElement*)[self.root elementWithKey:@"WPA_LABEL"]).value = network.wpa ? NSLocalizedString(@"MSG_YES", @"YES"):NSLocalizedString(@"MSG_NO", @"NO");
        
        [self.quickDialogTableView reloadData];
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"POPOVER_BTN_NETWORK_LIST", @"Networks");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
