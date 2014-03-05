/*
 * WANetworkData.m
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

#import "WANetworkData.h"

@implementation WANetworkData

@synthesize essid;
@synthesize bssid;
@synthesize channel;
@synthesize mode;
@synthesize rssi;
@synthesize wep;
@synthesize wpa;

-(id)initWithDictionary:(NSDictionary *)values
{
    self = [super init];
    if (self) {
        essid = [values objectForKey:@"SSID_STR"];
        bssid = [values objectForKey:@"BSSID"];
        channel = [(NSString*)[values objectForKey:@"CHANNEL"]integerValue];
        
        NSNumber *apmode = [values objectForKey:@"AP_MODE"];
        if ([apmode isEqualToNumber:[NSNumber numberWithInt:1]]) {
            mode = @"AdHoc";
        } else if ([apmode isEqualToNumber:[NSNumber numberWithInt:2]]) {
            mode = @"Infrastructure";
        } else {
            mode = [NSString stringWithFormat:@"%d", [mode intValue]];
        }
        
        rssi = [NSString stringWithFormat:@"%@ dBm", [values objectForKey:@"RSSI"]];
        wep = [[values objectForKey:@"WEP"] boolValue];
        wpa = [[values objectForKey:@"WPA_IE"]boolValue];
                
    }
    return self;
}

@end
