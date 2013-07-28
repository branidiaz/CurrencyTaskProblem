//
//  ConnectionLayer.h
//  CurrencyTask
//
//  Created by Abraham Tomás Díaz Abreu on 27/07/13.
//  Copyright (c) 2013 Abraham Tomás Díaz Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionLayer : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>


@property (nonatomic,copy)NSURLRequest *request;
@property (nonatomic,copy) void (^completionBlock)(id obj, NSError*err);

-(id)initWithRequest:(NSURLRequest *)req;
-(void)start;

@end
