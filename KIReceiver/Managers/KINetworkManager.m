//
//  KINetworkManager.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 31.10.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KINetworkManager.h"
#import "KINetworkLog.h"

NSString *const API_URL = @"https://api.getkisi.com";
NSString *const ENDPOINT_URL = @"locks";
NSString *const ACTION_URL = @"access";

@implementation KINetworkManager {
    NSURLSession *_session;
    NSURLSessionConfiguration *_config;
    __block KINetworkLog *logger;
    BOOL shouldOutputDebugInfo;
}

@synthesize networkDelegate;

-(id)initWithDelegate:(id<KINetworkDelegate>)delegate {
    self = [super init];
    if (self) {
        networkDelegate = delegate;
        
        // Setup the session
        _config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _config.HTTPAdditionalHeaders = @{
                                        @"Authorization" : @"KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c",
                                        @"User-Agent":@"KIReceiver 1.0"
                                        };
        _session = [NSURLSession sessionWithConfiguration:_config];
        
        // Initialize the logger object
        logger = [KINetworkLog new];
        
    }
    return self;
}

- (void)setDebugEnabled:(BOOL)debugEnabled {
    shouldOutputDebugInfo = debugEnabled;
}

- (void)requestUnlockForNumber:(NSString *)lockNumber {
    NSString *stringUrl = [NSString stringWithFormat:@"%@/%@/%@/%@", API_URL, ENDPOINT_URL, lockNumber, ACTION_URL];
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // We use __block here so we can capture the unlockTask variable in the block call
    __block NSURLSessionDataTask *unlockTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // If debug is enabled, we output CURL-like request infos
        if (shouldOutputDebugInfo) {
            [self outputLogsForRequest:unlockTask andResponseData:data andError:error];
        }
        
        if (!error) {
            NSError *jsonError;
            NSMutableDictionary *jsonResponseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (jsonError) {
                // JSON encoding error occured, we don't treat in here.
            } else {
                if ([jsonResponseObject.allKeys containsObject:@"error"]) {
                    // We don't have access to unlock
                } else {
                    // We can unlock
                    if (networkDelegate) {
                        [networkDelegate managerDidUnlock];
                    }
                }
            }
        } else {
            NSLog(@"a request error has occured: %@", error.localizedDescription);
        }
    }];
    
    [unlockTask resume];
}

#pragma mark Helper methods

- (void)outputLogsForRequest:(NSURLSessionTask *)task andResponseData:(NSData *) data andError:(NSError *) error {
    [logger logForTask:task andPayload:data andError:error];
}

@end
