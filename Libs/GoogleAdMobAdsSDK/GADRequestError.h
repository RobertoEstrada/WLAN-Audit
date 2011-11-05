//
//  GADRequestError.h
//  Google AdMob Ads SDK
//
//  Copyright 2011 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GADRequest;

extern NSString *kGADErrorDomain;

// NSError codes for GAD error domain.
typedef enum {
  // The ad request is invalid.  The localizedFailureReason error description
  // will have more details.  Typically this is because the ad did not have the
  // ad unit ID or root view controller set.
  kGADErrorInvalidRequest,

  // The ad request was successful, but no ad was returned.
  kGADErrorNoFill,

  // There was an error loading data from the network.
  kGADErrorNetworkError,

  // The ad server experienced a failure processing the request.
  kGADErrorServerError,

  // The current device's OS is below the minimum required version.
  kGADErrorOSVersionTooLow,

  // The request was unable to be loaded before being timed out.
  kGADErrorTimeout,

  // The mediation request encountered an error.
  kGADMediationError,

} GADErrorCode;

// This class represents the error generated due to invalid request parameters.
@interface GADRequestError : NSError

@end
