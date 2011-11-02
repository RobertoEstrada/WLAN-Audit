/*
 * NetworkDetailsController.m
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

#import "KeyListController.h"
#import "NetworkDetailsController.h"
#import "WiFiXXXXXXKeyCalculator.h"
#import "WLANXXXXKeyCalculator.h"

#define NETWORK_BASIC_DATA_SECTION 0
#define NETWORK_ADDITIONAL_DATA_SECTION 1
#define COPY_KEYS_BUTTON_SECTION 2

#define NUMBER_OF_SECTIONS 3

/* 2 Elements: ESSID and BSSID */
#define ELEMENTS_IN_BASIC_DATA_SECTION 2
/* 5 Elements: Channel,Mode,RSSI,WEP,WPA */
#define ELEMENTS_IN_ADDITIONAL_DATA_SECTION 5
/* 1 Element: Copy keys button */
#define ELEMENTS_IN_COPY_KEYS_SECTION 1

@implementation NetworkDetailsController

@synthesize networkDetails,wlanKeys;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [wlanKeys release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"network_details", "Network details");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case NETWORK_BASIC_DATA_SECTION:
            return ELEMENTS_IN_BASIC_DATA_SECTION;
        case NETWORK_ADDITIONAL_DATA_SECTION:
            return ELEMENTS_IN_ADDITIONAL_DATA_SECTION; 
        case COPY_KEYS_BUTTON_SECTION:
            return ELEMENTS_IN_COPY_KEYS_SECTION;
        default:
            break;
    }
    return 0;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case NETWORK_BASIC_DATA_SECTION:
            return NSLocalizedString(@"network_basic_data_section", @"Network name");
        case NETWORK_ADDITIONAL_DATA_SECTION:
            return NSLocalizedString(@"network_additional_data_section", @"Network data");
        case COPY_KEYS_BUTTON_SECTION:
            return NSLocalizedString(@"copy_keys_button_section", @"Keys");
    }
    return nil;
}

#pragma mark -
#pragma mark Data formatting methods

-(NSString*) formattedBSSIDfrom:(NSString*)bssid {
	NSScanner *scanner = [NSScanner scannerWithString:bssid];
	[scanner setCharactersToBeSkipped:[NSCharacterSet punctuationCharacterSet]];
	NSMutableString *result = [NSMutableString stringWithCapacity:[bssid length]];
	while (![scanner isAtEnd]) {
		unsigned theValue;
		if ([scanner scanHexInt:&theValue]) {
			[result appendFormat:@":%02x",theValue];
		} else {
			[result appendString:@":??"];
		}
	}
	return [result substringFromIndex:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *cellValue;
    
    // Configure the cell...
    switch (indexPath.section) {
        case NETWORK_BASIC_DATA_SECTION:
            switch (indexPath.row) {
                case 0:
                    // ESSID
                    cell.textLabel.text = @"ESSID";
                    cellValue = [NSString stringWithFormat:@"%@",[networkDetails objectForKey:@"SSID_STR"]];
                    cell.detailTextLabel.text = cellValue;
                    break;
                case 1:
                    // BSSID
                    cell.textLabel.text = @"BSSID";
                    cellValue = [[self formattedBSSIDfrom:[networkDetails objectForKey:@"BSSID"]]uppercaseString];
                    cell.detailTextLabel.text = cellValue;
                    break;
            }            
            break;
        case NETWORK_ADDITIONAL_DATA_SECTION:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"channel", @"Channel");
                    cellValue = [NSString stringWithFormat:@"%@",[networkDetails objectForKey:@"CHANNEL"]];
                    cell.detailTextLabel.text = cellValue;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"mode", @"Mode");
                    NSNumber *mode = [networkDetails objectForKey:@"AP_MODE"];
                    if([mode isEqualToNumber:[NSNumber numberWithInt:1]]){
                        cellValue = @"AdHoc";
                    }else if([mode isEqualToNumber:[NSNumber numberWithInt:2]]){
                        cellValue = @"Infrastructure";
                    }else{
                        cellValue = [NSString stringWithFormat:@"%d",mode];
                    }
                    cell.detailTextLabel.text = cellValue;
                    break;
                case 2:
                    cell.textLabel.text = @"RSSI";
                    cellValue = [NSString stringWithFormat:@"%@ dBm",[networkDetails objectForKey:@"RSSI"]];
                    cell.detailTextLabel.text = cellValue;
                    break;
                case 3:
                    cell.textLabel.text = @"WEP";
                    cellValue = [NSString stringWithFormat:@"%@",[[networkDetails objectForKey:@"WEP"] boolValue] ? @"YES":@"NO"];
                    cell.detailTextLabel.text = cellValue;
                    break;
                case 4:
                    cell.textLabel.text = @"WPA";                    
                    cellValue = [NSString stringWithFormat:@"%@",[networkDetails objectForKey:@"WPA_IE"] ? @"YES":@"NO"];
                    cell.detailTextLabel.text = cellValue;
                    break;    
            }            
            break;
        case COPY_KEYS_BUTTON_SECTION:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"network_keys", @"Show network keys");
                    cell.detailTextLabel.text = @"";
            }
            break;
        default:
            break;
    }    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == COPY_KEYS_BUTTON_SECTION && indexPath.row == 0) {
		if (!([networkDetails objectForKey:@"WPA_IE"] || [[networkDetails objectForKey:@"WEP"] boolValue])) {
			UIAlertView *msgBox = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"unsafe_ap_title",@"AP seguro, no tiene clave")
															 message:NSLocalizedString(@"no_key_ap_message",@"El AP no tiene clave.")
															delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
			[msgBox show];
			} else {
			
			// Network data
			NSString *wlanESSID  = [NSString stringWithFormat:@"%@",[networkDetails objectForKey:@"SSID_STR"]];
			NSString *wlanBSSID =  [[self formattedBSSIDfrom:[networkDetails objectForKey:@"BSSID"]]uppercaseString];
			
			// Key calculation
			NSPredicate *wlanxxxx = [NSPredicate predicateWithFormat:@"SELF MATCHES 'WLAN_....|JAZZTEL_....'"];
			NSPredicate *wifixxxxxx = [NSPredicate predicateWithFormat:@"SELF MATCHES 'WLAN......|YACOM......|WiFi......'"];
			
			// Result
			if ([wlanxxxx evaluateWithObject:wlanESSID]){
				// WLAN_XXXX Code
				self.wlanKeys = [WLANXXXXKeyCalculator calculateKeyWithESSID:wlanESSID BSSID:wlanBSSID];
			}else if([wifixxxxxx evaluateWithObject:wlanESSID]) {
				// WiFiXXXXXX Code
				self.wlanKeys = [WiFiXXXXXXKeyCalculator calculateKeyWithESSID:wlanESSID BSSID:wlanBSSID];
			}else {        
				self.wlanKeys = nil;
			}
			
			
			// Result display
			if (wlanKeys != nil && [wlanKeys count] == 1) {
				// There's only one key
				UIAlertView *msgBox = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"unsafe_ap_title",@"AP Inseguro, clave encontrada")
																 message:[NSString stringWithFormat:NSLocalizedString(@"unsafe_ap_message",
																													  @"Se pudo calcular una posible clave por defecto a traves de los datos publicos.\n\nSi no se trata de tu AP, avisa a su propietario de que cambie la clave de su red.\n\nLa clave de la red %@ parece ser:\n%@"),
																		  wlanESSID,[self.wlanKeys objectAtIndex:0]]
																delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:NSLocalizedString(@"copy_button",@"Copiar"),nil] autorelease];
				[msgBox show];
				
			}else if (wlanKeys != nil && [wlanKeys count] > 1){
				// Multiple keys need to be displayed
				KeyListController *keyListController = [[KeyListController alloc] initWithNibName:@"KeyListController" bundle:nil];
				keyListController.keyList = self.wlanKeys;
				keyListController.wlanESSID = wlanESSID;
				[self.navigationController pushViewController:keyListController animated:YES];
				[keyListController release];
			}else {
				UIAlertView *msgBox = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"safe_ap_title",@"AP seguro, clave no encontrada")
																 message:NSLocalizedString(@"safe_ap_message",@"No se pudo encontrar la clave, el AP no tiene una clave que pueda ser calculada mediante sus datos publicos.")
																delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
				[msgBox show];
			}
		}

    }
}

#pragma mark -
#pragma mark Alert view delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[UIPasteboard generalPasteboard].string = (NSString*) [self.wlanKeys objectAtIndex:0];
	}
	
}

@end
