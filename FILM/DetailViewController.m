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

#pragma mark - life cycle
//viewDidLoad里面只做addSubview的事情
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchText.delegate = self;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"twinkle1" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    webViewBG.userInteractionEnabled = NO;
    [self.view addSubview:webViewBG];
    [self.view sendSubviewToBack:webViewBG];
    
    self.searchText.alpha = 0.4;
    self.Poster.alpha = 0.0;
}

//viewWillAppear里面做布局的事情
- (void)viewWillAppear:(BOOL)animated {
    if (currentOrientation == UIDeviceOrientationLandscapeLeft || currentOrientation == UIDeviceOrientationLandscapeRight) {
        self.plotLabelWidth.constant = 200;
        self.trailingMarginValue.constant = 0;
    } else {
        self.plotLabelWidth.constant = 628;
        self.trailingMarginValue.constant = 180;
    }
}

//viewDidAppear里面做Notification的监听之类的事情
- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

#pragma mark - 键盘处理
//点击视图隐藏键盘
- (IBAction)View_TouchDown:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - 自动布局处理
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

#pragma mark - 搜索按钮点击事件及搜索处理
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
                self.titleLabel.textColor = [UIColor whiteColor];
                self.releasedLabel.textColor = [UIColor whiteColor];
                self.ratingLabel.textColor = [UIColor whiteColor];
                self.plotLabel.textColor = [UIColor whiteColor];
                self.titleLabel.text = [jsonResult objectForKey:@"Title"];
                self.releasedLabel.text = [jsonResult objectForKey:@"Released"];
                self.ratingLabel.text = [jsonResult objectForKey:@"imdbRating"];
                self.plotLabel.text = [jsonResult objectForKey:@"Plot"];
                self.Poster.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonResult objectForKey:@"Poster"]]]];
                self.Poster.alpha = 1.0;
                NSLog(@"%@",jsonResult);
            });
        }
        
    }];
    [task resume];
    
    [self.searchText resignFirstResponder];
}

#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
