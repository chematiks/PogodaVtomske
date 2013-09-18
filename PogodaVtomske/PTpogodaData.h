//
//  PTpogodaData.h
//  parserHTML
//
//  Created by Администратор on 8/8/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTprognozNaDay.h"
#import "HTMLNode.h"

@interface PTpogodaData : NSObject

@property (nonatomic, strong) NSString * currentTemp; // текущая температура
@property (nonatomic, strong) NSString * currentOblachnost; // текущая облачность
@property (nonatomic, strong) NSString * currentCloudImage; // картинка текущей облачности
@property (nonatomic, strong) NSString * currenttime;
@property (nonatomic, strong) NSMutableArray * forecastOnTenDay;


@end
