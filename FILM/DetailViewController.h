//
//  DetailViewController.h
//  FILM
//
//  Created by helicopter on 15/10/27.
//  Copyright © 2015年 helicopter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

