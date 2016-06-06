//
//  DetailViewController.h
//  Guidebook
//
//  Created by Madhav Devendra Sahu on 6/3/16.
//  Copyright (c) 2016 Madhav Devendra Sahu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

