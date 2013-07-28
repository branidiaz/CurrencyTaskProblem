//
//  Node.h
//  CurrencyTask
//
//  Created by Abraham Tomás Díaz Abreu on 27/07/13.
//  Copyright (c) 2013 Abraham Tomás Díaz Abreu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject



@property(nonatomic,strong)NSString * keyValue;
@property(nonatomic,strong)NSDecimalNumber* valor;
@property(nonatomic) BOOL visited;
@end
