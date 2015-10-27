//
//  ViewController.m
//  FilmDB
//
//  Created by helicopter on 15/10/25.
//  Copyright © 2015年 helicopter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *releasedLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonPressed:(id)sender {
    NSString *searchText = [NSString stringWithFormat:@"%@",self.searchTextField.text];
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
                self.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonResult objectForKey:@"Poster"]]]];
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
