/*
 * WANetworkDetailsViewController.m
 *
 * Copyright 2013 Roberto Estrada
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

@interface WANetworkDetailsViewController ()

@end

@implementation WANetworkDetailsViewController

-(QRootElement*)setupDialog
{
    QRootElement *dialogRoot = [[QRootElement alloc] init];
    
    dialogRoot.grouped = YES;
    dialogRoot.controllerName = NSStringFromClass([WANetworkDetailsViewController class]);
    
    QSection *ssidSection = [[QSection alloc] initWithTitle:NSLocalizedString(@"NET_SSID_SECTION_LABEL", @"Network name")];
    QLabelElement *essidLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_ESSID_LABEL", @"ESSID") Value:nil];
    QLabelElement *bssidLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_BSSID_LABEL", @"BSSID") Value:nil];
    [ssidSection addElement: essidLabel];
    [ssidSection addElement:bssidLabel];
    
    QSection *detailsSection = [[QSection alloc] initWithTitle:NSLocalizedString(@"NET_DETAILS_SECTION_LABEL", @"Details")];
    QLabelElement *channelLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_CHANNEL_LABEL", @"Channel") Value:nil];
    QLabelElement *modeLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_MODE_LABEL", @"Mode") Value:nil];
    QLabelElement *rssiLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_RSSI_LABEL", @"RSSI") Value:nil];
    QLabelElement *wepLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_WEP_LABEL", @"WEP") Value:nil];
    QLabelElement *wpaLabel = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"NET_WPA_LABEL", @"WPA") Value:nil];
    [detailsSection addElement:channelLabel];
    [detailsSection addElement:modeLabel];
    [detailsSection addElement:rssiLabel];
    [detailsSection addElement:wepLabel];
    [detailsSection addElement:wpaLabel];
    
    [dialogRoot addSection:ssidSection];
    [dialogRoot addSection:detailsSection];
    
    return dialogRoot;
}

@end
