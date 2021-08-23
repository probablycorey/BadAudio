//
//  ViewController.m
//  BadAudio
//
//  Created by Corey Johnson on 8/20/21.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@implementation ViewController

AVCaptureSession *session;
AVCaptureAudioDataOutput *output;

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)start:(id)sender {
    NSString *airPodId = [self airPodId];
    if (!airPodId) {
        NSLog(@"No airpods found, you need airpods (or some other bluetooth audio) to see this bug");
        exit(1);
    }
    
    session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *audioDevice = [AVCaptureDevice deviceWithUniqueID:airPodId];
    
    AVCaptureDeviceInput *audioDeviceinput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    output = [AVCaptureAudioDataOutput new];
    
    if (![session canAddInput:audioDeviceinput]) {
        NSLog(@"FAILED TO ADD INPUT");
        exit(1);
    }
    
    if (![session canAddOutput:output]) {
        NSLog(@"FAILED TO ADD OUTPUT");
        exit(1);
    }
    
    [session beginConfiguration];
    [session addInput:audioDeviceinput];
    [session addOutput:output];
    [session commitConfiguration];

    [session startRunning];
}

- (IBAction)stop:(id)sender {
    [session stopRunning];
}


- (NSString *)airPodId {
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio] == AVAuthorizationStatusAuthorized) {
        AVCaptureDeviceDiscoverySession *session = [AVCaptureDeviceDiscoverySession
                    discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone]
                    mediaType:AVMediaTypeAudio
                    position:AVCaptureDevicePositionUnspecified];

        NSArray<AVCaptureDevice *> *devices = [session devices];
        
        for (AVCaptureDevice *audioDevice in devices) {
            if ([[audioDevice localizedName] containsString:@"Beoplay"]) {
                NSLog(@"Using device named %@ with id %@", [audioDevice localizedName], [audioDevice uniqueID]);
                return [audioDevice uniqueID];
            }
        }
    }
    
    return nil;
}

@end
