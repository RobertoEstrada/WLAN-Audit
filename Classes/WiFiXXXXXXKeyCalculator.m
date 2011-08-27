/*
 * WiFiXXXXXXKeyCalculator.m
 *
 * Copyright 2011 Roberto Estrada
 *
 * Algorithm by Mambostar (www.seguridadwireless.net)
 * Original code by NirozMe|on from WLAN4X (www.seguridadwireless.net)
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

#import "WiFiXXXXXXKeyCalculator.h"


@implementation WiFiXXXXXXKeyCalculator

+(NSArray*) calculateKeyWithESSID:(NSString*)essid BSSID:(NSString*)bssid {
    // Result list
    NSMutableArray *resultList = [NSMutableArray array];
    
    // Algorithm variables
    int i;
    int X1,X2,X3,Y1,Y2,Y3,Z1,Z2,Z3,W1,W2,W3,W4,K1,K2,S7;
    
    // Buffers for string manipulation
    char *essid_c = (char*) malloc(sizeof(char)*[essid length]);
    char *bssid_c = (char*) malloc(sizeof(char)*[bssid length]);
    
    // Converting data from NSStrings
    strcpy(essid_c, [essid UTF8String]);
    strcpy(bssid_c, [bssid UTF8String]);
    
    for(i=0;i<=strlen(essid_c);i++)
    {
    	if(essid_c[i] >= 65) essid_c[i] -= 55;
    }
	
    for(i=0;i<=strlen(bssid_c);i++)
    {
    	if(bssid_c[i] >= 65) bssid_c[i] -= 55;
    }
	
	
    i=0;
    if (strlen(essid_c)==11) i=1;
    
    char S8=essid_c[7+i]&15,S9=essid_c[8+i]&15,S10=essid_c[9+i]&15;
    char M9=essid_c[5+i],M10=essid_c[6+i]&15,M11=bssid_c[15],M12=bssid_c[16];
    
    for(S7=0;S7<=9;S7++)
    {
        K1 = (S7+S8+M11+M12);
        K2 = (M9+M10+S9+S10);
        X1 = K1^S10;
        X2 = K1^S9;
        X3 = K1^S8;
        Y1 = K2^M10;
        Y2 = K2^M11;
        Y3 = K2^M12;
        Z1 = M11^S10;
        Z2 = M12^S9;
        Z3 = K1^K2;
        W1 = X1^Z2;
        W2 = Y2^Y3;
        W3 = Y1^X3;
        W4 = Z3^X2;
        
        [resultList addObject:[NSString stringWithFormat:@"%X%X%X%X%X%X%X%X%X%X%X%X%X",W4&15,X1&15,Y1&15,Z1&15,W1&15,X2&15,Y2&15,Z2&15,W2&15,X3&15,Y3&15,Z3&15,W3&15]];
        
    }    
    
    // Freeing memory
    free(essid_c);
    free(bssid_c);
    
    // Return result
    return resultList;
}

@end
