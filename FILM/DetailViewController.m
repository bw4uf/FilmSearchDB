//
//  DetailViewController.m
//  FILM
//
//  Created by helicopter on 15/10/27.
//  Copyright © 2015年 helicopter. All rights reserved.
//

#import "DetailViewController.h"

#define currentOrientation     [[UIApplication sharedApplication] statusBarOrientation]
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *releasedLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (weak, nonatomic) IBOutlet UILabel *plotLabel;

@property (weak, nonatomic) IBOutlet UITextField *searchText;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *trailingMarginValue;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *plotLabelWidth;

@property (weak, nonatomic) IBOutlet UIImageView *Poster;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        self.detailDescriptionLabel.text = @"Display";
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    if (currentOrientation == UIDeviceOrientationLandscapeLeft || currentOrientation == UIDeviceOrientationLandscapeRight) {
        self.plotLabelWidth.constant = 200;
        self.trailingMarginValue.constant = 0;
    } else {
        self.plotLabelWidth.constant = 628;
        self.trailingMarginValue.constant = 180;
    }
    
    [self configureView];
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    if (currentOrientation == UIDeviceOrientationLandscapeLeft || currentOrientation == UIDeviceOrientationLandscapeRight) {
        self.plotLabelWidth.constant = 200;
        self.trailingMarginValue.constant = 0;
    } else {
        self.plotLabelWidth.constant = 628;
        self.trailingMarginValue.constant = 180;
    }
    
    
}
- (IBAction)searchButtonPressed:(id)sender {
    NSString *searchText = [NSString stringWithFormat:@"%@",self.searchText.text];
    [self searchFilmDB:searchText];
}

- (void)searchFilmDB:(NSString *)content
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@",content];
    NSURL *urlPath = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:urlPath completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"error%@",error);
        }
        else{
            NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.titleLabel.text = [jsonResult objectForKey:@"Title"];
                self.releasedLabel.text = [jsonResult objectForKey:@"Released"];
                self.ratingLabel.text = [jsonResult objectForKey:@"Rated"];
                self.plotLabel.text = [jsonResult objectForKey:@"Plot"];
                self.Poster.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonResult objectForKey:@"Poster"]]]];
                NSLog(@"%@",jsonResult);
            });
        }
        
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
