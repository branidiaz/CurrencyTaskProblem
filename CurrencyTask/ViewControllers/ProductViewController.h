//
//  ProductViewController.h
//  CurrencyTask
//
//  Created by Abraham Tomás Díaz Abreu on 27/07/13.
//  Copyright (c) 2013 Abraham Tomás Díaz Abreu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductViewControllerDelegate <NSObject>
@optional

-(void)dismissViewController;

@end

@interface ProductViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *product;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) id<ProductViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
- (IBAction)dismissVC:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil forProduct:(NSString*) product withValue:(NSString*)value bundle:(NSBundle *)nibBundleOrNil;
@end
