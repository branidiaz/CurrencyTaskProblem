//
//  ViewController.h
//  CurrencyTask
//
//  Created by Abraham Tomás Díaz Abreu on 27/07/13.
//  Copyright (c) 2013 Abraham Tomás Díaz Abreu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Node.h"
#import "ConnectionLayer.h"
#import "Transaction.h"
#import "NSMutableArray+QueueAdditions.h"
#import "ProductCell.h"
#import "ProductViewController.h"
#import "CollectionProductCell.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ProductViewControllerDelegate>

//@property (nonatomic, weak) IBOutlet UITableView *tableproducts;
@property (nonatomic, strong)  UITableView *tableproducts;
@property (nonatomic, strong) ProductViewController *productViewController;
@property (nonatomic, copy) NSString* indexCheck;
@property (nonatomic, strong) NSMutableDictionary *valuesOfRates;
@property (nonatomic, strong) NSMutableDictionary *nodes;
@property (nonatomic, strong) NSMutableDictionary *rateConvertion;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionProducts;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;



-(void) getTransaction;
-(void) getRates;

-(NSDecimalNumber*) calculate :(NSString*) sku ;




@end
