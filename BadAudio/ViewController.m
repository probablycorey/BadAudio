//
//  ViewController.m
//  BadAudio
//
//  Created by Corey Johnson on 8/20/21.
//

#import "ViewController.h"
#import "MacOSDevices.h"


@implementation ViewController

MacOSAudioLevel *audioLevel;
NSTimer *timer;

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)start:(id)sender {
// Use this to get the airPod id
// NSMutableDictionary<NSString *, NSMutableDictionary *> *devices = [MacOSDevices audio];
// NSLog(@"%@", devices);
    
    NSString *airPodsId = @"e4-90-fd-8f-8c-56:input";
    audioLevel = [[MacOSAudioLevel alloc] init];
    [audioLevel start:airPodsId];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
        target:self
        selector:@selector(level)
        userInfo:nil
        repeats:YES];
}

- (IBAction)stop:(id)sender {
    [timer invalidate];
    [audioLevel stop];
}

- (void)level {
    NSLog(@"%f", [audioLevel getAverageLevel]);
}

@end
