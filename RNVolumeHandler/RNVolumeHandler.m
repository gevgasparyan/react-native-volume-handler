//
//  RNVolumeHandler.m
//  RNVolumeHandler
//
//  Created by Gevorg Gasparyan on 9/18/17.
//  Copyright © 2017 Gevorg Gasparyan. All rights reserved.
//

#import "RNVolumeHandler.h"
#import <MediaPlayer/MediaPlayer.h>


@interface RNVolumeHandler ()

@property (nonatomic, strong) AVAudioSession * session;
@property (nonatomic, strong) MPVolumeView   * volumeView;
@property (nonatomic, assign) BOOL             isStarted;

@end

@implementation RNVolumeHandler

#pragma mark - Init

- (id)init {
    self = [super init];
    
    if (self) {
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(MAXFLOAT, MAXFLOAT, 0, 0)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].windows.firstObject addSubview:_volumeView];
        });
        
        _volumeView.hidden = YES;
        
    }
    return self;
}

- (void)dealloc {
    [self stopHandler];
    [self.volumeView removeFromSuperview];
}

- (void)startHandler {
    [self setupSession];
    self.volumeView.hidden = NO; // Start visible to prevent changes made during setup from showing default volume
    
    // There is a delay between setting the volume view before the system actually disables the HUD
    [self performSelector:@selector(setupSession) withObject:nil afterDelay:1];
}

- (void)stopHandler {
    if (!self.isStarted) {
        // Prevent stop process when already stop
        return;
    }
    
    self.isStarted = NO;
    
    self.volumeView.hidden = YES;
}

- (void)setupSession {
    if (self.isStarted){
        // Prevent setup twice
        return;
    }
    
    self.isStarted = YES;
    
    NSError *error = nil;
    self.session = [AVAudioSession sharedInstance];
    
    [self.session setCategory:AVAudioSessionCategoryAmbient
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    [self.session setActive:YES error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    self.volumeView.hidden = YES;
}

#pragma mark - Convenience

+ (instancetype)volumeButtonHandler {
    RNVolumeHandler *instance = [[RNVolumeHandler alloc] init];
    return instance;
}

@end
