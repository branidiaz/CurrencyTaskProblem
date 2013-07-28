//
//  ConnectionLayer.m
//  CurrencyTask
//
//  Created by Abraham Tomás Díaz Abreu on 27/07/13.
//  Copyright (c) 2013 Abraham Tomás Díaz Abreu. All rights reserved.
//

#import "ConnectionLayer.h"
#import "NSString+SBJSON.h"

static NSMutableArray *sharedConnectionList = nil;

@interface ConnectionLayer () {
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@end

@implementation ConnectionLayer


#pragma mark - init


-(id)initWithRequest:(NSURLRequest *)req {
    self=[super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}


-(void)start {
    container= [[NSMutableData alloc]init];
    
    internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if (!sharedConnectionList) {
        sharedConnectionList= [[NSMutableArray alloc] init];
    }
    
    [sharedConnectionList addObject:self];
    
}

#pragma mark - NSURLConnection Delegate methods



-(void) connection:(NSURLConnection*) connection
    didReceiveData:(NSData *)data{
    
    [container appendData:data];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *post = [[NSString alloc] initWithData:container encoding:NSUTF8StringEncoding];
    
    
    id dictionary = [post JSONValue];
    
    

    
    if ([self completionBlock]) {
        [self completionBlock](dictionary,nil);
    }
    
    [sharedConnectionList removeObject:self];
    
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
    if ([self completionBlock]) {
        [self completionBlock](nil,error);
    }
    
    [sharedConnectionList removeObject:self];
    
}



@end
