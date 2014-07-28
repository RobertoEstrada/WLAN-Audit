/*
 * WANetworkData.h
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

#import <Realm/Realm.h>

@interface WANetworkData : RLMObject

@property NSString* essid;
@property NSString* bssid;

@property NSInteger channel;
@property NSString* mode;
@property NSString* rssi;
@property BOOL wep;
@property BOOL wpa;

-(id)initWithDictionary:(NSDictionary*) values;

@end
