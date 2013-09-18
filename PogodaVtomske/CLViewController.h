//
//  CLViewController.h
//  PogodaVtomske
//
//  Created by Администратор on 8/17/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTpogodaData.h"
#import "PullToRefreshScrollView.h"

@interface CLViewController : UIViewController <UITableViewDataSource, PullToRefreshScrollViewDelegate>
{
    NSMutableArray * wallpapers;
    NSMutableArray * wallpapersDeg;
    NSInteger nomerDay;
    NSInteger todayInt;
    int indetest;
    float alfa;
    float screenHeigth;
}
@property (weak, nonatomic) IBOutlet UIImageView *degradationWallpaper;
@property (weak, nonatomic) IBOutlet UILabel *currentTemp;
@property (weak, nonatomic) IBOutlet UIImageView *wallpapersImage;
@property (weak, nonatomic) IBOutlet PullToRefreshScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *table10Day;
@property (weak, nonatomic) IBOutlet UILabel *tempDayPrognoz;
@property (weak, nonatomic) IBOutlet UILabel *tempNigthPrognoz;
@property (weak, nonatomic) IBOutlet UILabel *currentCloudingTitle;
@property (weak, nonatomic) IBOutlet UIImageView *currentCloudImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageAir;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sunImage;
@property (weak, nonatomic) IBOutlet UIImageView *sunStepImage;
@property (weak, nonatomic) IBOutlet UIImageView *moonImage;

@property (strong, nonatomic) NSString * baseURL;
@property (strong, nonatomic) PTpogodaData * dataPogoda;
@property (strong, nonatomic) HTMLParser * parser;
@property (strong, nonatomic) HTMLParser * todayParser;

-(void) backgroundPotok;
-(int) downLoadData;
-(void) refreshData;
-(void) parserData;
-(void) refreshScrollView;
-(float) stringToFloat:(NSString *)string;
-(void) degradationController:(float) coordY;

@end
