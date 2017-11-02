//
//  KINetworkLog.h
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KINetworkLog : NSObject

// Log method that outputs CURL-like reponse in the console
-(void)logForTask:(NSURLSessionTask *)task andPayload:(id)payload andError:(NSError *)error;

@end
