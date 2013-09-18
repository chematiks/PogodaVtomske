//
//  PTprognozNaDay.h
//  parserHTML
//
//  Created by Администратор on 8/8/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h"

@interface PTprognozNaDay : NSObject

@property (nonatomic,strong) NSString * tempday;
@property (nonatomic,strong) NSString * tempnigth;
@property (nonatomic,strong) NSString * cloudImageURL;
@property (nonatomic,strong) NSString * sunrise;
@property (nonatomic,strong) NSString * sunset;
@property (nonatomic,strong) NSString * longitude;
@property (nonatomic,strong) NSString * moonURL;
-(PTprognozNaDay *) parsWeatherForDay:HTMLNodeWeather;

@end
