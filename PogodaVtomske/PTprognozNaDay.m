//
//  PTprognozNaDay.m
//  parserHTML
//
//  Created by Администратор on 8/8/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "PTprognozNaDay.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

@implementation PTprognozNaDay

@synthesize tempday=_tempday;
@synthesize tempnigth=_tempnigth;
@synthesize cloudImageURL=_cloudImageURL;
@synthesize sunrise=_sunrise;
@synthesize sunset=_sunset;
@synthesize longitude=_longitude;
@synthesize moonURL=_moonURL;

-(PTprognozNaDay *) parsWeatherForDay:HTMLNodeWeather
{
    PTprognozNaDay * prognoz=[[PTprognozNaDay alloc] init];
    NSArray * massivTd=[HTMLNodeWeather findChildTags:@"td"];
    //получаем облачность
    NSString * stroka=[[massivTd objectAtIndex:1] rawContents];
    NSRange rang;
    NSUInteger posleNadpisi=[stroka rangeOfString:@"alt="].location;
    NSUInteger peredNadpisi=[stroka rangeOfString:@"src="].location;
    rang.length=ABS(posleNadpisi-peredNadpisi)-7;
    rang.location=peredNadpisi+5;
    prognoz.cloudImageURL=[stroka substringWithRange:rang];
    //получаем температуру
    NSString *tempstroka=[[massivTd objectAtIndex:2] allContents];
    NSRange rangtemp;
    rangtemp.length=[tempstroka length]-([tempstroka rangeOfString:@"День: "].location+7);
    rangtemp.location=[tempstroka rangeOfString:@"День: "].location+6;
    NSString * tempDayStr=[tempstroka substringWithRange:rangtemp];
    rangtemp.location=0;
    rangtemp.length=[tempDayStr rangeOfString:@" "].location-3;
    prognoz.tempday=[tempDayStr substringWithRange:rangtemp];
    rangtemp.length=[tempstroka length]-([tempstroka rangeOfString:@"Ночь: "].location+7);
    rangtemp.location=[tempstroka rangeOfString:@"Ночь: "].location+6;
    if (rangtemp.location < 1000){
        NSString * tempNigthStr=[tempstroka substringWithRange:rangtemp];
        rangtemp.location=0;
        rangtemp.length=[tempNigthStr rangeOfString:@" "].location-3;
        prognoz.tempnigth=[tempNigthStr substringWithRange:rangtemp];
    }
    else prognoz.tempnigth=@"   ";
    HTMLNode * sun=[massivTd objectAtIndex:5];
    NSString * sunStr=[sun allContents];
    NSRange rangeSun;
    rangeSun.location=[sunStr rangeOfString:@"восход:"].location+8;
    NSRange rangeSunTemp;
    rangeSunTemp.location=rangeSun.location;
    rangeSunTemp.length=6;
    rangeSun.length=([sunStr rangeOfString:@":" options:NSCaseInsensitiveSearch range: rangeSunTemp].location+3)-rangeSun.location;
    NSString * suntemp=[sunStr substringWithRange:rangeSun];
    prognoz.sunrise=suntemp;
    
    rangeSun.location=rangeSun.location+rangeSun.length;
    rangeSun.length=[sunStr length ]-rangeSun.location;
    sunStr = [sunStr substringWithRange:rangeSun];
    
    rangeSun.location=[sunStr rangeOfString:@"закат:"].location+7;
    rangeSunTemp.location=rangeSun.location;
    rangeSunTemp.length=6;
    rangeSun.length=([sunStr rangeOfString:@":" options:NSCaseInsensitiveSearch range: rangeSunTemp].location+3)-rangeSun.location;
    NSString * moontemp=[sunStr substringWithRange:rangeSun];
    prognoz.sunset=moontemp;
        
    rangeSun.location=rangeSun.location+rangeSun.length;
    rangeSun.length=[sunStr length ]-rangeSun.location;
    sunStr = [sunStr substringWithRange:rangeSun];
    
    rangeSun.location=[sunStr rangeOfString:@"долгота:"].location+9;
    rangeSunTemp.location=rangeSun.location;
    rangeSunTemp.length=6;
    rangeSun.length=([sunStr rangeOfString:@":" options:NSCaseInsensitiveSearch range: rangeSunTemp].location+3)-rangeSun.location;
    NSString * lengthtemp=[sunStr substringWithRange:rangeSun];
    prognoz.longitude=lengthtemp;
    
    NSString * moon=[[massivTd objectAtIndex:6] rawContents];
    NSRange rangMoon;
    NSUInteger posleURL=[moon rangeOfString:@"alt="].location;
    NSUInteger peredURL=[moon rangeOfString:@"src="].location;
    rangMoon.length=ABS(posleURL-peredURL)-7;
    rangMoon.location=peredURL+5;
    prognoz.moonURL=[moon substringWithRange:rangMoon];
    return prognoz;
}





@end
