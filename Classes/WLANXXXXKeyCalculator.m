/*
 * WLANXXXXKeyCalculator.m
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

#import <CommonCrypto/CommonDigest.h>
#import "WLANXXXXKeyCalculator.h"

// Definition of router kinds
#define COM_KIND 1
#define ZYX_KIND 2
#define UNK_KIND 3

@implementation WLANXXXXKeyCalculator

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
    ];
}

+ (NSInteger)getRouterKind:(NSString *)bssid {

    // Regular expressions to determine which router kind is being audited
    NSPredicate *com_kind_bssids = [NSPredicate predicateWithFormat:@"SELF MATCHES '(((64:68:0C|00:1D:20)|(00:1B:20|00:23:F8)):[0-9A-Fa-f:]{8})'"];
    NSPredicate *zyx_kind_bssids = [NSPredicate predicateWithFormat:@"SELF MATCHES '(00:1F:A4:[0-9A-Fa-f:]{8})'"];

    if ([com_kind_bssids evaluateWithObject:bssid]) {
        return COM_KIND;
    } else if ([zyx_kind_bssids evaluateWithObject:bssid]) {
        return ZYX_KIND;
    }

    return UNK_KIND;
}

+ (NSArray *)calculateKeyWithESSID:(NSString *)essid BSSID:(NSString *)bssid {

    NSPredicate *validSSIDs = [NSPredicate predicateWithFormat:@"SELF MATCHES '(?:WLAN|JAZZTEL)_([0-9a-fA-F]{4})'"];

    NSString *trimmedBSSID = [bssid stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *formattedESSID = nil;
    NSString *stringToHash = nil;

    // Removing name from the ESSID, we only want the numbers
    if (([essid rangeOfString:@"JAZZTEL_"].location != NSNotFound) && [validSSIDs evaluateWithObject:essid]) {
        formattedESSID = [[essid stringByReplacingOccurrencesOfString:@"JAZZTEL_" withString:@""] uppercaseString];
    } else if ([essid rangeOfString:@"WLAN_"].location != NSNotFound && [validSSIDs evaluateWithObject:essid]) {
        formattedESSID = [[essid stringByReplacingOccurrencesOfString:@"WLAN_" withString:@""] uppercaseString];
    }
    if (formattedESSID == nil) {
        return nil;
    }

    // Determine router kind
    NSInteger routerKind = [WLANXXXXKeyCalculator getRouterKind:bssid];
    // Processing range
    NSRange rng = {0, 8};

    switch (routerKind) {
        case COM_KIND:
            trimmedBSSID = [trimmedBSSID uppercaseString];
            // Key calculation            
            stringToHash = [NSString stringWithFormat:@"%@%@%@%@", @"bcgbghgg", [trimmedBSSID substringWithRange:rng], formattedESSID, trimmedBSSID];
            break;
        case ZYX_KIND:
            formattedESSID = [formattedESSID lowercaseString];
            trimmedBSSID = [trimmedBSSID lowercaseString];
            stringToHash = [[NSString stringWithFormat:@"%@%@", [trimmedBSSID substringWithRange:rng], formattedESSID] lowercaseString];
            break;
        case UNK_KIND:
            return nil;
    }

    // Hashing
    NSRange resultrange = {0, 20};
    NSArray *result = [NSArray arrayWithObject:[[[self md5:stringToHash] substringWithRange:resultrange] lowercaseString]];
    return result;
}

@end
