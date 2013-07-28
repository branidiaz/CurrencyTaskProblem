//
//  ViewController.m
//  CurrencyTask
//
//  Created by Abraham Tomás Díaz Abreu on 27/07/13.
//  Copyright (c) 2013 Abraham Tomás Díaz Abreu. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CURRENCY @"EUR"
#define FRAME_CELL 75

@interface ViewController () {

    NSMutableArray *listofTransaction, *listofDistincTransactions,*listofRates,*ratesinfo;
   // ProductView *productView;
    
    
    CollectionProductCell *generalCell;
    
    
    NSIndexPath *indexPathSelected;

    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDatas];
    [self getTransaction];
    [self getRates];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init and parse datas

-(void) getTransaction  {
    
    NSLog(@"Get Transaction");
    
    NSString *urlAsString = @"http://quiet-stone-2094.herokuapp.com/transactions.json";
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    ConnectionLayer* connection = [[ConnectionLayer alloc] initWithRequest:request];
    
    [connection setCompletionBlock:^(NSMutableDictionary*  transactions, NSError*error){
        
        if (!error) {

            [listofTransaction setArray:[self transactionArray:transactions]];
            
            NSLog(@"the size of the array is %d",[listofTransaction count]);
            
            NSSet *tran = [NSSet setWithArray:[listofTransaction valueForKey:@"name"]];
            listofDistincTransactions = [NSMutableArray arrayWithArray:[tran allObjects]];
            
            NSLog(@"the size of the array sss is %d",[listofDistincTransactions count]);
            
            NSLog(@"the size of the array sss is %@",[listofDistincTransactions objectAtIndex:3]);
            
            //[self.tableproducts reloadData];
            [self.collectionProducts reloadData];


        }
        else {
            NSString* errorString = [NSString stringWithFormat:@"Connection failed:%@",[error localizedDescription]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
        
    }];
    
    [connection start];
    
    
}

-(void) getRates {
    
    
    NSLog(@"Get Rates");
    
    NSString *urlAsString = @"http://quiet-stone-2094.herokuapp.com/rates.json";
    
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    ConnectionLayer* connection = [[ConnectionLayer alloc] initWithRequest:request];
    
    [connection setCompletionBlock:^(NSArray* rates, NSError*error){
        
        
        
        
        if (!error) {
            
            
            self.valuesOfRates= [self parseRates:rates];
            
            [self initNodes];
                    }
        else {
            
            
            NSString* errorString = [NSString stringWithFormat:@"Connection failed:%@",[error localizedDescription]];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
        
    }];
    
    [connection start];
    
    
    
}

-(NSMutableArray*)transactionArray:(NSMutableDictionary*)listOfDictionaries {

    NSMutableArray *transactions =[[NSMutableArray alloc]init];

    for (NSDictionary *trans in listOfDictionaries)
    {
        Transaction *t = [[Transaction alloc] init];
        [t setName:[trans objectForKey:@"sku"]];
        [t setAmount:[trans objectForKey:@"amount"]];
        [t setCurrency:[trans objectForKey:@"currency"]];
        
        [transactions addObject:t];
        
    }

    return transactions;
  
}

-(NSMutableDictionary *) parseRates:(NSArray*)rates {
    
    //  NSMutableArray *rates =[[NSMutableArray alloc]init];
    
        NSMutableDictionary *keys = [[NSMutableDictionary alloc] init];
    
    
    for (NSDictionary *ra in rates)
    {
        
        NSString *valueFrom =[ra objectForKey:@"from"];
        if ([keys objectForKey:valueFrom]!= nil) {
            NSMutableDictionary *ratesValues = [[NSMutableDictionary alloc] init];
            
            ratesValues = [keys objectForKey:valueFrom];
//            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//            [f setNumberStyle:NSNumberFormatterDecimalStyle];
//            NSNumber * myNumber = [f numberFromString:[ra objectForKey:@"rate"]];
            
            NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:[ra objectForKey:@"rate"]];
            
            NSString * valueTo =[ra objectForKey:@"to"];
            //[ratesValues setObject:myNumber forKey:valueTo];
            [ratesValues setObject:number forKey:valueTo];
            
            
        } else {
            NSMutableDictionary *ratesValues = [[NSMutableDictionary alloc] init];
//            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//            [f setNumberStyle:NSNumberFormatterDecimalStyle];
//            
//            NSNumber * myNumber = [f numberFromString:[ra objectForKey:@"rate"]];
            
            NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:[ra objectForKey:@"rate"]];
            
            NSString * valueTo =[ra objectForKey:@"to"];
           // [ratesValues setObject:myNumber forKey:valueTo];
            
            [ratesValues setObject:number forKey:valueTo];
            
            NSString * valueFrom =[ra objectForKey:@"from"];
            [keys setObject:ratesValues forKey:valueFrom];
        }
        
        
        
        
        
        //
        //
        //        Rate *rate = [[Rate alloc] init];
        //        [rate setFrom:[ra objectForKey:@"from"]];
        //        [rate setTo:[ra objectForKey:@"to"]];
        //        [rate setRate:[ra objectForKey:@"rate"]];
        //
        //        [rates addObject:rate];
        
    }
    
    
    return keys;
    
}

-(void)initNodes {
    
    
    NSArray * array = [self.valuesOfRates allKeys];
    
    for (int i=0; i<[array count]; i++) {
        Node* node = [[Node alloc]init];
        node.keyValue = [array objectAtIndex:i] ;
        node.visited = false;
        [self.nodes setObject:node forKey:node.keyValue];
        
    }
    
    
    
}

-(void)initDatas {
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(getTransaction)];
    
    self.navigationItem.rightBarButtonItem = button;
    self.title=@"Financial products";
    listofTransaction =[[NSMutableArray alloc]init];
    listofDistincTransactions =[[NSMutableArray alloc]init];
    listofRates =[[NSMutableArray alloc]init];
    self.valuesOfRates = [[NSMutableDictionary alloc]init];
    self.indexCheck= [[NSString alloc]init];
    self.nodes = [[NSMutableDictionary alloc]init];
    self.rateConvertion = [[NSMutableDictionary alloc]init];
    UINib *cellNib = [UINib nibWithNibName:@"CollectionProductCell" bundle:nil];
    [self.collectionProducts registerNib:cellNib forCellWithReuseIdentifier:@"CollectionProduct"];
    [self.backgroundImage setImage:[UIImage imageNamed:@"backgroundImage.png"]];

    
}


#pragma mark - Algorithms

-(NSDecimalNumber*) calculate :(NSString*) sku {
    NSDecimalNumber *decimal = [[NSDecimalNumber alloc ]initWithFloat:0.0];
    for (int i=0; i <[listofTransaction count]; i++) {
        Transaction *t =(Transaction*) [listofTransaction objectAtIndex:i];
        if ([[t name]isEqualToString:sku]){
            if ([[t currency] isEqualToString:CURRENCY] ) {
                decimal = [decimal decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:[t amount]]];
   
            }
            else {
                if ([self.rateConvertion objectForKey:[t currency]] != nil) {
                    
                    
                    NSDecimalNumber* aux=[[self.rateConvertion objectForKey:[t currency]]decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString:[t amount]]];
                    
                    decimal =[decimal decimalNumberByAdding:aux];

                    
                } else {
                    [self initNodes];
                    
                    
                    // BFS algorithm 
//                    NSDecimalNumber* aux1=[[self BFS:[t currency]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[t amount]]];
                    
                    
                    NSDecimalNumber* aux=[[self DFS:[t currency]:[t currency]:[NSDecimalNumber decimalNumberWithString:@"1"]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[t amount]]];
                    
                    
                    decimal =[decimal decimalNumberByAdding:aux];

                }
                
          
            }
            
            
        }
    }
    return decimal;
}

-(NSDecimalNumber*) DFS: (NSString*)rootNodeString :(NSString*)origin :(NSDecimalNumber*)acum {
    
    if (rootNodeString == nil) {
        return 0;
    }
    Node* rootNode = [self.nodes objectForKey:rootNodeString ];
    rootNode.keyValue = rootNodeString;
    rootNode.visited= TRUE;
    rootNode.valor =acum;
    NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:@"0"];
    
    NSMutableDictionary * rateValues = [self.valuesOfRates objectForKey:rootNode.keyValue];
    
    NSArray *keys = [rateValues allKeys];
    
    for (int i=0; i<[keys count]; i++) {
        
        
        Node* n = [self.nodes objectForKey:[keys objectAtIndex:i] ];
        n.valor = [[rateValues objectForKey:n.keyValue] decimalNumberByMultiplyingBy: rootNode.valor ];
        if ([n.keyValue isEqualToString:CURRENCY]) {
            
            [self.rateConvertion setObject:n.valor forKey:origin];
            num = [n valor];
            
        }
        if (n.visited== false) {
            n.visited = TRUE;
             [self DFS:n.keyValue:origin:n.valor ];
        }
        
        
        
    }
    
    return num;
}

-(NSDecimalNumber*) BFS: (NSString*)rootNodeString {

    NSMutableArray *queue = [[NSMutableArray alloc]init];

    Node* rootNode = [[Node alloc] init];
    rootNode.keyValue = rootNodeString;
    rootNode.visited= TRUE;
    rootNode.valor =[NSDecimalNumber decimalNumberWithString:@"1"];
    [queue enqueue:rootNode];
    
    while ([queue count]>0) {

        Node *node = (Node *)[queue dequeue]; 
        NSMutableDictionary * rateValues = [self.valuesOfRates objectForKey:node.keyValue];
        NSArray *keys = [rateValues allKeys];
        for (int i=0; i<[keys count]; i++) {
            
            Node* n = [self.nodes objectForKey:[keys objectAtIndex:i] ];
            n.valor =[[rateValues objectForKey:n.keyValue] decimalNumberByMultiplyingBy:node.valor];
            
            if ([n.keyValue isEqualToString:CURRENCY]) {
                
                [self.rateConvertion setObject:n.valor forKey:rootNode.keyValue];
                return n.valor;
                
            }
            if (n.visited== false) {
                n.visited = TRUE;
                [queue enqueue:n];
            }
            
        }  
        
    }
    return 0;
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
   
    return [listofDistincTransactions count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    
    CollectionProductCell *cell = (CollectionProductCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionProduct" forIndexPath:indexPath];
    

        
        
        [cell.labelProduct setText:[listofDistincTransactions objectAtIndex:[indexPath row]]];
        //cell.backgroundColor = [UIColor whiteColor];
       cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];


    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = NO;
 //   cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 0.0f;
    cell.layer.contentsScale = [UIScreen mainScreen].scale;
    cell.layer.shadowOpacity = 0.6f;
    cell.layer.shadowRadius = 0.6f;

    cell.layer.shadowOffset = CGSizeMake(-4,4);
   // cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
    cell.layer.shouldRasterize = YES;

   
        return cell; 
    

}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self animateZoomIn:indexPath];
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath 
{
    
    return CGSizeMake(FRAME_CELL,FRAME_CELL);
}


- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark –ProductViewControllerDelegate

-(void)dismissViewController {
    
    
    [self animateZoomOut];
    
}

#pragma mark – Animations ZoomIn - ZoomOut

-(void)animateZoomIn:(NSIndexPath*)indexPath {
    
    CollectionProductCell *cell = (CollectionProductCell*)[self.collectionProducts cellForItemAtIndexPath:indexPath];
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.fromValue = [NSValue valueWithCGRect:cell.frame];
	boundsAnimation.toValue = [NSValue valueWithCGRect:self.collectionProducts.bounds];
    
	CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithCGPoint:cell.layer.position];
	positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.collectionProducts.bounds), CGRectGetMidY(self.collectionProducts.bounds))];
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
	group.duration = 0.5;
	group.animations = [NSArray arrayWithObjects:boundsAnimation, positionAnimation, nil];
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	group.delegate = self;
	[cell.layer addAnimation:group forKey:@"zoomIn"];
    // cell.frame =self.collectionProducts.bounds;
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0f];
    [cell.labelProduct setHidden:YES];
    [self.collectionProducts bringSubviewToFront:cell];
    generalCell = cell;
    indexPathSelected = indexPath;
    
}


-(void)animateZoomOut {
    
	
	CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.fromValue = [NSValue valueWithCGRect:self.collectionProducts.bounds];
	boundsAnimation.toValue = [NSValue valueWithCGRect:generalCell.bounds];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.collectionProducts.bounds), CGRectGetMidY(self.collectionProducts.bounds))];;
	positionAnimation.toValue = [NSValue valueWithCGPoint:generalCell.layer.position];
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.duration = 0.5;
	group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, nil];
	group.delegate = self;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
    generalCell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
	[generalCell.layer addAnimation:group forKey:@"zoomOut"];
    
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (anim == [generalCell.layer animationForKey:@"zoomIn"]) {
        
        NSString *product = [listofDistincTransactions objectAtIndex:[indexPathSelected row]];
        NSString *amount = [NSString stringWithFormat:@"%@",[self calculate:[listofDistincTransactions objectAtIndex:[indexPathSelected row]]]];
        
        self.productViewController = [[ProductViewController alloc]initWithNibName:@"ProductViewController" forProduct:product withValue:amount bundle:nil];
        self.productViewController.delegate = self;
        
        
        NSLog(@" altura %f",generalCell.frame.origin.y);
        
        // [self.navigationController pushViewController:self.productViewController animated:NO];
        
        
        [self.navigationController  presentViewController:self.productViewController animated:NO completion:nil];
	} else {
        [generalCell.labelProduct setHidden:NO];
    }
    
    
    
}





@end
