/*
 * WASimulatorNetworksManager.m
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

#import "WASimulatorNetworksManager.h"

static WASimulatorNetworksManager *NetworksManager;

@implementation WASimulatorNetworksManager

+ (WASimulatorNetworksManager *)sharedNetworksManager {
	if (!NetworksManager)
		NetworksManager = [[WASimulatorNetworksManager alloc] init];
	return NetworksManager;
}

- (id)init {
	NetworksManager = self;
	networks = [[NSMutableDictionary alloc] init];
	return self;
}

- (void)scan {
	NSLog(@"Scanning...");
	scanning = true;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"startedScanning" object:self];
    
	NSDictionary *network1  = @{ @"SSID_STR": @"WLAN_A5B1", @"BSSID": @"64:68:0C:1B:3B:05", @"CHANNEL": @1, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network2  = @{ @"SSID_STR": @"JAZZTEL_75EA", @"BSSID": @"00:23:F8:B5:93:F8", @"CHANNEL": @2, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network3  = @{ @"SSID_STR": @"WLAN4A9E2B", @"BSSID": @"00:16:3E:A3:07:76", @"CHANNEL": @3, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network4  = @{ @"SSID_STR": @"DLink-A5B1AA", @"BSSID": @"00:16:3E:E6:0A:55", @"CHANNEL": @4, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network5  = @{ @"SSID_STR": @"DLink-630643", @"BSSID": @"00:1C:14:39:27:4F", @"CHANNEL": @5, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network6  = @{ @"SSID_STR": @"HWEI", @"BSSID": @"04:C0:6F:60:7F:08", @"CHANNEL": @6, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network7  = @{ @"SSID_STR": @"HWEI", @"BSSID": @"00:19:15:C9:5E:EA", @"CHANNEL": @7, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network8  = @{ @"SSID_STR": @"Discus--630643", @"BSSID": @"00:1C:14:39:27:4F", @"CHANNEL": @8, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network9  = @{ @"SSID_STR": @"WLAN_BF42", @"BSSID": @"38:72:C0:82:DF:8E", @"CHANNEL": @9, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
	NSDictionary *network10 = @{ @"SSID_STR": @"JAZZTEL_1234", @"BSSID": @"00:1A:2B:11:22:33", @"CHANNEL": @10, @"AP_MODE": @2, @"RSSI":@"15", @"WEP": @YES };
    
	NSArray *scan_networks = @[network1, network2, network3, network4, network5, network6, network7, network8, network9, network10];
    
	for (int i = 0; i < [scan_networks count]; i++) {
		[networks setObject:[scan_networks objectAtIndex:i] forKey:[[scan_networks objectAtIndex:i] objectForKey:@"BSSID"]];
	}
    
	// Sleeps for two seconds, to simulate a real network scan
	[NSThread sleepForTimeInterval:2];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"stoppedScanning" object:self];
	NSLog(@"Scan Finished...");
}

@end
