//
//  RNVolumeManager.m
//  RNVolumeHandler
//
//  Created by Gevorg Gasparyan on 9/18/17.
//  Copyright © 2017 Gevorg Gasparyan. All rights reserved.
//

#import "RNVolumeManager.h"
#import "RNVolumeHandler.h"

@implementation RNVolumeManager

bool hasListeners;
static RNVolumeHandler* volumeHandler;

RCT_EXPORT_MODULE();

-(void)startObserving {
    hasListeners = YES;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(volumeChanged:)
     name:@"AVSystemController_SystemVolumeDidChangeNotification"
     object:nil];
    
    if (!volumeHandler)
    {
        volumeHandler = [RNVolumeHandler volumeButtonHandler];
    }
}

-(void)stopObserving {
    hasListeners = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (volumeHandler)
    {
        [volumeHandler stopHandler];
        volumeHandler = nil;
    }
}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"onVolumeButtonPress"];
}

- (void)volumeChanged:(NSNotification *)notification
{
    if (!hasListeners) {
        return;
    }
    if([[notification.userInfo objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"])
    {
        float volume = [[[notification userInfo]
                         objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
                        floatValue];
        [self sendEventWithName:@"onVolumeButtonPress" body:@{@"volume": @(volume)}];
    }
}

RCT_EXPORT_METHOD(hide)
{
    if (volumeHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [volumeHandler startHandler];
        });
    }
}

RCT_EXPORT_METHOD(show)
{
    if (volumeHandler)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [volumeHandler stopHandler];
        });
    }
}

@end
