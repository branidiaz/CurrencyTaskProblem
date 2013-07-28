//
//  ProductViewController.m
//  CurrencyTask
//
//  Created by Abraham Tomás Díaz Abreu on 27/07/13.
//  Copyright (c) 2013 Abraham Tomás Díaz Abreu. All rights reserved.
//

#import "ProductViewController.h"

@interface ProductViewController () {
    
    NSString * bankProduct;
    NSString * value;
    
}

@end

@implementation ProductViewController

- (IBAction)dismissVC:(id)sender {
  //  [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([self.delegate respondsToSelector:@selector(dismissViewController)]) {
        [self.delegate dismissViewController];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil forProduct:(NSString*) p withValue:(NSString*)v bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bankProduct=p;
        value = v;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE];
    
    NSDecimalNumber *myNumber = [NSDecimalNumber decimalNumberWithString:value];
    
    NSDecimalNumber *roundedDecimalNumber = [myNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    [self.navTitle setTitle:[NSString stringWithFormat:@"Product: %@",bankProduct]];
    [self.amount setText:[NSString stringWithFormat:@"%@ €",roundedDecimalNumber]];
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
