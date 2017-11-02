//
//  KINetworkLog.m
//  KIReceiver
//
//  Created by Alexandru Frangeti on 01.11.2017.
//  Copyright © 2017 Alexandru Frangeti. All rights reserved.
//

#import "KINetworkLog.h"

@interface KINetworkLog()

@end

@implementation KINetworkLog

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)logForTask:(NSURLSessionTask *)task andPayload:(id)payload andError:(NSError *)error {
    NSURLRequest *request = task.originalRequest;
    NSURLResponse *response = task.response;
    NSInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
    
    [self printRequest:request response:response statusCode:@(statusCode) payload:payload error:error];
}

#pragma mark Private

-(void)printRequest:(NSURLRequest*)request response:(NSURLResponse*)response statusCode:(NSNumber*)statusCode payload:(id)payload error:(NSError *)error {
    
    // input params
    NSString *urlString = request.URL.absoluteString;
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    
    NSString *method = request.HTTPMethod !=nil ? request.HTTPMethod : @"";
    NSString *path = components.path;
    NSString *query = components.query;
    NSString *host = components.host;
    
    NSString *requestLog = @"\n> ";
    requestLog = [requestLog stringByAppendingString:urlString];
    requestLog = [requestLog stringByAppendingString:@"\n"];
    if (query) {
        requestLog = [requestLog stringByAppendingString:[NSString stringWithFormat:@"> %@ %@?%@ HTTP1.1\n", method, path, query]];
    } else {
        requestLog = [requestLog stringByAppendingString:[NSString stringWithFormat:@"> %@ %@ HTTP1.1\n", method, path]];
    }
    requestLog = [requestLog stringByAppendingString:[NSString stringWithFormat:@"> Host: %@\n", host]];
    
    for (NSDictionary *httpHeader in request.allHTTPHeaderFields) {
        requestLog = [requestLog stringByAppendingString:[NSString stringWithFormat:@"> %@: %@\n", [httpHeader.allKeys objectAtIndex:0], [httpHeader objectForKey:[httpHeader.allKeys objectAtIndex:0]]]];
    }
    
    if (request.HTTPBody) {
        requestLog = [requestLog stringByAppendingString:[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    }
    
    // output params
    urlString = response.URL.absoluteString;
    components = [NSURLComponents componentsWithString:urlString];
    path = components.path;
    query = components.query;
    host = components.host;
    
    NSString *responseLog = @"< ";
    responseLog = [responseLog stringByAppendingString:urlString];
    responseLog = [responseLog stringByAppendingString:@"\n"];
    if (query) {
        responseLog = [responseLog stringByAppendingString:[NSString stringWithFormat:@"< HTTP/1.1 %@ %@?%@\n", statusCode, path, query]];
    } else {
        responseLog = [responseLog stringByAppendingString:[NSString stringWithFormat:@"< HTTP/1.1 %@ %@\n", statusCode, path]];
    }
    
    responseLog = [responseLog stringByAppendingString:[NSString stringWithFormat:@"< Server: %@\n", host]];
    
    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    for (NSString *key in headers) {
        responseLog = [responseLog stringByAppendingString:[NSString stringWithFormat:@"< %@ %@\n", key, [headers objectForKey:key]]];
    }
    
    if (payload) {
        responseLog = [responseLog stringByAppendingString:@"<\n"];
        responseLog = [responseLog stringByAppendingString:[[NSString alloc] initWithData:payload encoding:NSUTF8StringEncoding]];
    }
    
    if (error != nil) {
        responseLog = [responseLog stringByAppendingString:[NSString stringWithFormat:@"< Error: %@", error.localizedDescription]];
    }
    
    NSLog(@"%@\n%@", requestLog, responseLog);
}

@end
