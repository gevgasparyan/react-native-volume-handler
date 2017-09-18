//
//  RNVolumeHandler.h
//  RNVolumeHandler
//
//  Created by Gevorg Gasparyan on 9/18/17.
//  Copyright © 2017 Gevorg Gasparyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface RNVolumeHandler : NSObject

- (void)startHandler;
- (void)stopHandler;

// Returns a button handler
+ (instancetype)volumeButtonHandler;

@end
