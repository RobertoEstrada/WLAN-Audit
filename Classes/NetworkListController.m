/*
 * NetworkListController.m
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

#import "AdMobView.h"
#import "AdDelegate.h"
#import "KeyCalculator.h"
#import "NetworkListController.h"
#import "MSNetworksManager.h"


@implementation NetworkListController

@synthesize wlanNetworks,wlanBSSIDS,wlanKey;

#pragma mark -
#pragma mark Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
	// Refresh button
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																				   target:self action:@selector(scanForNetworks)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
	// About button
	UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithTitle:@"?" style:UIBarButtonItemStylePlain
																   target:self action:@selector(showAboutBox)];
	self.navigationItem.leftBarButtonItem = aboutButton;
	[aboutButton release];
	
	// Notification of scan completion
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSourceUpdated) name:@"stoppedScanning" object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self scanForNetworks];
	// Ad load	
	[AdMobView requestAdWithDelegate:[[AdDelegate alloc]initWithViewController:self]];
}

#pragma mark -
#pragma mark UI Event handler methods

- (void)scanForNetworks {
	MSNetworksManager *wlanManager = [MSNetworksManager sharedNetworksManager];
    [wlanManager removeAllNetworks];
	[wlanManager scan];
}

- (void)showAboutBox {
	NSString *refURL = @"http://kz.ath.cx/wlan/codigo.txt";
	NSString *sourceURL = @"https://github.com/RobertoEstrada/WLAN-Audit";
	NSString *buildDate = [NSString stringWithUTF8String:__DATE__];
	UIAlertView *msgBox = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"about_title",@"Acerca de...")
													 message:[NSString stringWithFormat:NSLocalizedString(@"about_message",
															  @"WLAN Audit ©2011 Roberto Estrada\n\nEsta es una aplicacion pensada para auditar la seguridad de las claves de acceso de los puntos de acceso WLAN comprobando si pueden ser calculadas a traves de los datos publicos de la red.No me responsabilizo del uso que pueda derivarse de esta aplicacion\n\nBasado en el codigo de %@\n\nPuedes descargar el codigo desde:\n%@\n\nCompilado:%@"),
															  refURL,sourceURL,buildDate]
													delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[msgBox show];
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

#pragma mark -
#pragma mark Table view data source

-(void) dataSourceUpdated {
	// Reloading data in the table view
	self.wlanNetworks = [[[MSNetworksManager sharedNetworksManager] networks] allValues];
	self.wlanBSSIDS = [[[MSNetworksManager sharedNetworksManager] networks] allKeys];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [wlanNetworks count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];		
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }	
    
    // Getting Network Data	
	NSString *wlanName  = [[wlanNetworks objectAtIndex:indexPath.row]objectForKey:@"SSID_STR"];
	NSString *wlanBSSID = [[self formattedBSSIDfrom:[wlanBSSIDS objectAtIndex:indexPath.row]]uppercaseString];
	
	// Configuring cell to show WLAN Data
	cell.textLabel.text = wlanName;
	cell.detailTextLabel.text = wlanBSSID;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Network data
	NSString *wlanESSID  = [[wlanNetworks objectAtIndex:indexPath.row]objectForKey:@"SSID_STR"];
	NSString *wlanBSSID = [[self formattedBSSIDfrom:[wlanBSSIDS objectAtIndex:indexPath.row]]uppercaseString];
	
	// Result
	self.wlanKey = [KeyCalculator calculateKeyWithESSID:wlanESSID BSSID:wlanBSSID];
	
	// Result display
	if (wlanKey != nil) {
		UIAlertView *msgBox = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"unsafe_ap_title",@"AP Inseguro, clave encontrada")
														 message:[NSString stringWithFormat:NSLocalizedString(@"unsafe_ap_message",
																											  @"Se pudo calcular una posible clave por defecto a traves de los datos publicos.\n\nSi no se trata de tu AP, avisa a su propietario de que cambie la clave de su red.\n\nLa clave de la red %@ parece ser:\n%@"),
																  wlanESSID,wlanKey]
														delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:NSLocalizedString(@"copy_button",@"Copiar"),nil] autorelease];
		[msgBox show];
		
	}else {
		UIAlertView *msgBox = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"safe_ap_title",@"AP seguro, clave no encontrada")
														 message:NSLocalizedString(@"safe_ap_message",@"No se pudo encontrar la clave, el AP no tiene una clave que pueda ser calculada mediante sus datos publicos.")
														delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
		[msgBox show];
	}
}

#pragma mark -
#pragma mark Alert view delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[UIPasteboard generalPasteboard].string = self.wlanKey;
	}
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[wlanNetworks release];
	[wlanBSSIDS release];
}


- (void)dealloc {
    [super dealloc];
}


@end

