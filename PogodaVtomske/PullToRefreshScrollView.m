//
//  PullToRefreshScrollView.m
//  PullToRefreshScroll
//
//  Created by Joshua Grenon on 2/21/11.
//  Copyright 2011 Josh Grenon. All rights reserved.
//
#import "CLViewController.h"
#import "CLAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PullToRefreshScrollView.h"
#define REFRESH_HEADER_HEIGHT 70.0f
@implementation PullToRefreshScrollView



@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize delegate1=_delegate1;


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
	
    // Показать заголовок
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if (screenH==480.0f) self.contentInset=UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT+70, 0, 0, 0);
    else self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
   
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
	
    // Обновить действии!
    [self refresh];
    
}

- (void)stopLoading {
    isLoading = NO;
	
    // Скрыть заголовка
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

-(void)dealloc
{
}

-(void)awakeFromNib
{
	textPull = @"Потяни чтобы обновить...";
	textRelease = @"Отпусти чтобы обновить...";
	textLoading =@"Загружаю...";
	//создание формы сверху
	refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, self.frame.size.width, REFRESH_HEADER_HEIGHT)];
	refreshHeaderView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.45];
	refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	//создание текста формы сверху
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    UIFont * customFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    refreshLabel.font = customFont;
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.textColor = [UIColor whiteColor];
    refreshLabel.shadowColor=[UIColor darkGrayColor];
    CGSize shadowSize;
    shadowSize.height=1;
    shadowSize.width=1;
    refreshLabel.shadowOffset=shadowSize;
    refreshLabel.text=self.textPull;
    
    //созадние и задание рисунка сверху
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    (REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);
	//создание вентилятора
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
	//включение всех объектов к форме сверху
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];	
	//включение формы к основному окну
	[self addSubview:refreshHeaderView];
	self.delegate = self;
    
    CGRect screenBound=[[UIScreen mainScreen] bounds];
    screenH=screenBound.size.height;
	[super awakeFromNib];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Сброс заголовка
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    //Это всего лишь демо. Переопределить этот метод с пользовательской действия перезагрузки.
    // Не забудьте позвонить StopLoading в конце.
   // тут надо вызвать функцию из CLViewController
    int test=0;
    [self.delegate1 refreshScrollView];
    
    if (test==0)
    {
        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:0];
    }
    else{}
}

-(void) setContentOffset:(CGPoint)contentOffset
{
   // NSLog(@"%f",contentOffset.y);
    float coordY=contentOffset.y;
    [self.delegate1 degradationController:coordY];
    [super setContentOffset:contentOffset];
}

@end
