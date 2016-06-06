//
//  MainTableViewController.h
//  Guidebook
//
//  Created by Madhav Devendra Sahu on 6/5/16.
//  Copyright (c) 2016 Madhav Devendra Sahu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController<NSURLConnectionDataDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aiv;



@end
