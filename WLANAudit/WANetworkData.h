/*
 * WANetworkData.h
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

#import <Foundation/Foundation.h>

@interface WANetworkData : NSObject

@property(nonatomic,strong) NSString* essid;
@property(nonatomic,strong) NSString* bssid;

@property(nonatomic,assign) NSInteger channel;
@property(nonatomic,strong) NSString* mode;
@property(nonatomic,strong) NSString* rssi;
@property(nonatomic,assign) BOOL wep;
@property(nonatomic,assign) BOOL wpa;

-(id)initWithDictionary:(NSDictionary*) values;

@end
