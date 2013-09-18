//
//  CLSplashScreenViewController.m
//  PogodaVtomske
//
//  Created by Администратор on 8/21/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLSplashScreenViewController.h"
#import "UIImage+ImageNamed568.h"

@interface CLSplashScreenViewController ()

@end

@implementation CLSplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage * image=[UIImage imageNamed568:@"Default"];
    self.splashImage.image=image;
}

@end
