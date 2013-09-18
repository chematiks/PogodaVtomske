//
//  CLViewController.m
//  PogodaVtomske
//
//  Created by Администратор on 8/17/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLViewController.h"
#import "CLCell.h"
#import "PTpogodaData.h"
#import "PTprognozNaDay.h"
#import "NSString+denNedeli.h"
#import "CLSplashScreenViewController.h"
#import "PullToRefreshScrollView.h"
#import "UIImage+ImageNamed568.h"

@interface CLViewController ()

@end

@implementation CLViewController



-(void) refreshScrollView
{
    //int test=[self refreshData];
    [self performSelectorInBackground:@selector(backgroundPotok) withObject:nil];
}

-(void) backgroundPotok
{
    int errorcode=[self downLoadData];
    if (errorcode>0)
        NSLog(@"ERROR!!!");
    [self performSelectorOnMainThread:@selector(refreshData) withObject:nil waitUntilDone:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    alfa=0.0;
    CGRect screenBound=[[UIScreen mainScreen] bounds];
    screenHeigth=roundf(screenBound.size.height);
    int displayHeigth=480;
    NSUInteger indwal=arc4random()%2;
    self.wallpapersImage.image=[wallpapers objectAtIndex:indwal];
    self.degradationWallpaper.image=[wallpapersDeg objectAtIndex:indwal];
    CGSize scrollSize= self.scrollView.contentSize;
    scrollSize.height=displayHeigth*2+48+200;
    self.scrollView.contentSize=scrollSize;
    CGRect tableY=self.table10Day.frame;
    tableY.origin.y=+displayHeigth+20+48;
    self.table10Day.frame=tableY;
    self.currentTemp.text=[self.dataPogoda.currentTemp stringByAppendingString:@"°"];
    NSDate * currentDate=[NSDate date];
    NSDateFormatter * format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"e"];
    NSString * string=[format stringFromDate:currentDate];
    nomerDay=[string integerValue];
    self.dataPogoda.currenttime=[self currentTime:currentDate];
    PTprognozNaDay * currentPrognoz=[self.dataPogoda.forecastOnTenDay objectAtIndex:0];
    self.tempDayPrognoz.text=[currentPrognoz.tempday stringByAppendingString:@"°"];
    self.tempNigthPrognoz.text=[currentPrognoz.tempnigth stringByAppendingString:@"°"];
    self.currentCloudingTitle.text=self.dataPogoda.currentOblachnost;
   
  /*  NSData * imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataPogoda.currentCloudImage]];
    UIImage * image=[UIImage imageWithData:imageData];
   */
    NSString * stringCloudImage=[self foungImageClouding:self.dataPogoda.currentCloudImage];
    UIImage * image=[UIImage imageNamed:stringCloudImage];
    self.currentCloudImage.image=image;
    
    self.scrollView.delegate1=self;
    CGRect imageAirSize=self.imageAir.frame;
    imageAirSize.origin.y=1008;
    int zero=1008;
    self.imageAir.frame=imageAirSize;
    int y=178;
    CGRect sunriseLabelRect=self.sunriseLabel.frame;
    sunriseLabelRect.origin.y=zero+y;
    sunriseLabelRect.origin.x=37;
    self.sunriseLabel.frame=sunriseLabelRect;
    CGRect sunsetLabelRect=self.sunsetLabel.frame;
    sunsetLabelRect.origin.y=zero+y;
    sunsetLabelRect.origin.x=255;
    self.sunsetLabel.frame=sunsetLabelRect;
    CGRect longitudeLabelRect=self.longitudeLabel.frame;
    longitudeLabelRect.origin.y=zero+y+3;
    longitudeLabelRect.origin.x=145;
    self.longitudeLabel.frame=longitudeLabelRect;
    self.sunriseLabel.text=currentPrognoz.sunrise;
    self.sunsetLabel.text=currentPrognoz.sunset;
    self.longitudeLabel.text=currentPrognoz.longitude;
    [self sunImageresresh:currentPrognoz];
    PTprognozNaDay * moonUrl1=[self.dataPogoda.forecastOnTenDay objectAtIndex:0];
    //NSLog(@"%@",moonUrl1.moonURL);
    NSString * moonUrl=@"";
    if (moonUrl1.moonURL)
        moonUrl=[self.baseURL stringByAppendingString: moonUrl1.moonURL];
    NSData * imageDataMoon=[NSData dataWithContentsOfURL:[NSURL URLWithString: moonUrl]];
    UIImage * imagemoon=[UIImage imageWithData:imageDataMoon];
    self.moonImage.image=imagemoon;
    CGRect moonKoord=self.moonImage.frame;
    moonKoord.origin.x=250;
    moonKoord.origin.y=1035;
    UIColor * colorCell=[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:alfa];
    self.imageAir.backgroundColor=colorCell;
    self.moonImage.frame=moonKoord;
    indetest=0;
}

-(void) sunImageresresh:(PTprognozNaDay *)prognoz
{
    int zero=1008;
    CGRect sunimagerect=self.sunImage.frame;
    sunimagerect.origin.y=zero+161;
    sunimagerect.origin.x=33;
    CGRect sunStepRect=self.sunStepImage.frame;
    float sunR=112.5;
    float t1=[self stringToFloat:prognoz.sunrise];
    float dt=[self stringToFloat:prognoz.longitude];
    float t=[self stringToFloat:self.dataPogoda.currenttime];
    int x=abs(roundf(225*((t-t1)/dt)));
    sunimagerect.origin.y=abs(roundf(sunimagerect.origin.y-sqrtf(sunR*sunR-(x-sunR)*(x-sunR))));
    sunStepRect.origin.y=zero+20;
    if ((t>=t1)&&(t<=(t1+dt)))
    {   sunimagerect.origin.x=sunimagerect.origin.x+x;
        sunStepRect.origin.x=47;
        sunStepRect.size.width=abs(x);
    }else{
        sunimagerect.origin.x=1000;
        sunStepRect.origin.x=1000;}
    self.sunStepImage.frame=sunStepRect;
    self.sunImage.frame=sunimagerect;
}

-(NSString *) currentTime:(NSDate *)currentDate
{
    NSDateFormatter * formatPoyas=[[NSDateFormatter alloc] init];
    [formatPoyas setDateFormat:@"Z"];
    NSString * poyas=[formatPoyas stringFromDate:currentDate];
    NSDateFormatter * formatCurrentTime=[[NSDateFormatter alloc]init];
    [formatCurrentTime setDateFormat:@"HH:mm"];
    NSString * currentTimestr=[formatCurrentTime stringFromDate:currentDate];
    if (!([poyas isEqualToString:@"+0700"]))
    {
        NSRange curTimeRange;
        curTimeRange.length=[currentTimestr rangeOfString:@":"].location;
        curTimeRange.location=0;
        NSString * strHour=[currentTimestr substringWithRange:curTimeRange];
        int timeH=[strHour intValue];
        NSRange poyasHrange;
        poyasHrange.location=1;
        poyasHrange.length=2;
        NSString * poyasHour=[poyas substringWithRange:poyasHrange];
        int poyasH=[poyasHour intValue];
        int hourMod;
        NSRange polusharie;
        polusharie.location=0;
        polusharie.length=1;
        if ([[poyas  substringWithRange:polusharie] isEqualToString:@"-"]) hourMod=timeH+poyasH+7;
        else hourMod=timeH-poyasH+7;
        curTimeRange.location=[currentTimestr rangeOfString:@":"].location+1;
        curTimeRange.length=2;
        int timeM=[[currentTimestr substringWithRange:curTimeRange] intValue];
        NSRange poyasMRange;
        poyasMRange.length=2;
        poyasMRange.location=3;
        int poyasM=[[poyas substringWithRange:poyasMRange] intValue];
        int minMod=timeM-poyasM;
        if (minMod<0) {
            minMod=minMod+60;
            hourMod--;}
        if (hourMod>23) hourMod=hourMod-24;
        if (hourMod<0) hourMod=hourMod+24;
        NSString * timeGod=[NSString stringWithFormat:@"%d:%d",hourMod,minMod];
        return timeGod;
    }else{ return currentTimestr;}
}

-(float) stringToFloat:(NSString *)string
{
    NSRange hourRange;
    hourRange.length=[string rangeOfString:@":"].location;
    hourRange.location=0;
    NSString * hourStr=[string substringWithRange:hourRange];
    NSRange minRange;
    minRange.length=2;
    minRange.location=hourStr.length+1;
    NSString * minStr=[string substringWithRange:minRange];
    float time=[hourStr floatValue]+[minStr floatValue]/60;
    return time;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(int) downLoadData
{
    NSError * error = nil;
    NSData * data=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.baseURL stringByAppendingString:@"/forecast10.html"]]];
    NSString * stroka=[[NSString alloc] initWithData:data encoding:NSWindowsCP1251StringEncoding];
    self.parser=[[HTMLParser alloc] initWithString:stroka error:&error];
    int errorcode=0;
    if (error)
    {
        NSLog(@"Error: %@", error);
        errorcode=error.code;
    }
    NSData * todayData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.baseURL stringByAppendingString:@"/index.html"]]];
    NSString * todaystr=[[NSString alloc] initWithData:todayData encoding:NSWindowsCP1251StringEncoding];
    self.todayParser=[[HTMLParser alloc] initWithString:todaystr error:&error];
    if (error)
    {
        NSLog(@"Error: %@", error);
        errorcode=error.code;

    }
  
    return errorcode;
}

-(void) parserData
{
    self.baseURL=@"http://pogodavtomske.ru";
    self.dataPogoda=[PTpogodaData alloc]; //создаем контейнер для данных
      //инициализируем URL и парсим
    [self downLoadData];
    self.dataPogoda.forecastOnTenDay=[NSMutableArray array];
    HTMLNode * todaybody=[self.todayParser body];

    HTMLNode * todayprognoz=[todaybody findChildWithAttribute:@"class" matchingName:@"center rc5" allowPartial:TRUE];
    HTMLNode * todayprognoz2=[todayprognoz findChildWithAttribute:@"class" matchingName:@"block rc5 b2" allowPartial:TRUE];
     HTMLNode * todayprognoz3=[todayprognoz2 findChildWithAttribute:@"class" matchingName:@"whdisplay" allowPartial:TRUE];
     NSArray * todayarray=[todayprognoz3 findChildTags:@"tr"];
     PTprognozNaDay * prognozToday=[[PTprognozNaDay alloc] parsWeatherForDay:[todayarray objectAtIndex:1]];
     [self.dataPogoda.forecastOnTenDay addObject:prognozToday];
     //Разбираем данные
     HTMLNode * bodyNode = [self.parser body]; // получаем родительский элемент
    // Берем id="temp" и получаем текущую температуру
     HTMLNode *currentWeather = [bodyNode findChildWithAttribute:@"class" matchingName:@"right rc5" allowPartial:TRUE];
     HTMLNode * currentWeather2=[currentWeather findChildTag:@"table"];
     HTMLNode * tempNode=[currentWeather2 findChildTag:@"p"];
     HTMLNode * tempNode2=[tempNode findChildTag:@"span"];
     NSString * strTemp=[tempNode2 allContents];
     NSRange range=[strTemp rangeOfString:@"c"];
     range.length=range.location-1;
     range.location=0;
     self.dataPogoda.currentTemp=[strTemp substringWithRange:range];
     //получаем текущую облачность
     //картинка
     NSString * currrentCloudImageURL=@" ";
     HTMLNode * cloud=[currentWeather2 findChildTag:@"img"];
     NSString * cloudImagestr=[cloud rawContents];
     NSRange cloudRange;
     NSUInteger posleURL=[cloudImagestr rangeOfString:@"title="].location;
     NSUInteger peredURL=[cloudImagestr rangeOfString:@"src="].location;
     cloudRange.length=ABS(posleURL -peredURL)-7;
     cloudRange.location=peredURL+5;
     currrentCloudImageURL=[cloudImagestr substringWithRange:cloudRange];
   
   //  NSLog(@"%@",currrentCloudImageURL);
    
    self.dataPogoda.currentCloudImage=[self.baseURL stringByAppendingString:currrentCloudImageURL];
     //текст
     NSArray * cloudFind=[currentWeather2 findChildTags:@"td"];
     HTMLNode * cloudiness=[cloudFind objectAtIndex:3];
     NSString * cloudStr=[cloudiness rawContents];
     NSRange cloudRang;
     NSUInteger posle=[cloudStr rangeOfString:@"</"].location;
     NSUInteger pered=[cloudStr rangeOfString:@"\">"].location;
     cloudRang.length=ABS(posle-pered)-17;
     cloudRang.location=pered+10;
     NSString* currentCloud=[cloudStr substringWithRange:cloudRang];
     self.dataPogoda.currentOblachnost=currentCloud;
     //---------------прогноз на сегодня--------------------
     HTMLNode * weeklyprognoz=[bodyNode findChildWithAttribute:@"class" matchingName:@"center rc5" allowPartial:TRUE];
     HTMLNode * weeklyprognoz2=[weeklyprognoz findChildWithAttribute:@"class" matchingName:@"block rc5 b2" allowPartial:TRUE];
     HTMLNode * weeklyprognoz3=[weeklyprognoz2 findChildWithAttribute:@"class" matchingName:@"whdisplay" allowPartial:TRUE];
     NSArray * weeklyprognoz4=[weeklyprognoz3 findChildTags:@"tr"];
     for (HTMLNode * weather in weeklyprognoz4)
     {
         NSString * test=[weather rawContents];
         if ([test rangeOfString:@"125px"].location<100)
         {
             PTprognozNaDay * prognoz1Day=[[PTprognozNaDay alloc] parsWeatherForDay:weather];
             [self.dataPogoda.forecastOnTenDay addObject:prognoz1Day];
         }
     }
     todayInt=0;
     wallpapers =[NSMutableArray array];
     UIImage * wallp1=[UIImage imageNamed568:@"Wallpaper1.jpg"];
     [wallpapers addObject:wallp1];
     UIImage * wallp2=[UIImage imageNamed568:@"wallpaper2.jpg"];
     [wallpapers addObject:wallp2];
     wallpapersDeg =[NSMutableArray array];
     UIImage * wallpD1=[UIImage imageNamed568:@"Wallpaper1deg.jpg"];
     [wallpapersDeg addObject:wallpD1];
     UIImage * wallpD2=[UIImage imageNamed568:@"wallpaper2deg.jpg"];
     [wallpapersDeg addObject:wallpD2];
}

-(void) refreshData
{
    [self parserData];
    self.currentTemp.text=[self.dataPogoda.currentTemp stringByAppendingString:@"°"];
    PTprognozNaDay * currentPrognoz=[self.dataPogoda.forecastOnTenDay objectAtIndex:0];
    self.tempDayPrognoz.text=[currentPrognoz.tempday stringByAppendingString:@"°"];
    self.tempNigthPrognoz.text=[currentPrognoz.tempnigth stringByAppendingString:@"°"];
    self.currentCloudingTitle.text=self.dataPogoda.currentOblachnost;
    //NSData * imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataPogoda.currentCloudImage]];
    //UIImage * image=[UIImage imageWithData:imageData];
    
    NSString * stringCloudImage=[self foungImageClouding:self.dataPogoda.currentCloudImage];
    UIImage * image=[UIImage imageNamed:stringCloudImage];
    self.currentCloudImage.image=image;
    self.sunriseLabel.text=currentPrognoz.sunrise;
    self.sunsetLabel.text=currentPrognoz.sunset;
    self.longitudeLabel.text=currentPrognoz.longitude;
    NSDate * currentDate=[NSDate date];
    NSDateFormatter * format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"e"];
    NSString * string=[format stringFromDate:currentDate];
    nomerDay=[string integerValue];
    self.dataPogoda.currenttime=[self currentTime:currentDate];
    [self sunImageresresh:currentPrognoz];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString * const cellId=@"cell";
    CLCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    NSString * denNed= [[NSString alloc] init];
    denNed=[denNed denNedeli:nomerDay];
    nomerDay++;
    if (![denNed isEqualToString:@"Суббота"])
    {if (![denNed isEqualToString: @"Воскресение"]){cell.denNedeli.textColor=[UIColor whiteColor];}}
    if (indexPath.row==0) {denNed=@"Сегодня";}
    if (indexPath.row==1) {denNed=@"Завтра";}
    if (indexPath.row<2) if (cell.denNedeli.textColor==[UIColor whiteColor]) {cell.denNedeli.textColor=[UIColor colorWithRed:1 green:1 blue:0.65 alpha:1];}
    cell.denNedeli.text=denNed;
    int index=indexPath.row;
    PTprognozNaDay * temp=[self.dataPogoda.forecastOnTenDay objectAtIndex:index];
    if([temp.tempnigth isEqualToString:@"   "]){ todayInt=1;}
    if (indexPath.row<([self.dataPogoda.forecastOnTenDay count]))
    {
        index=index+todayInt;
        PTprognozNaDay * day=[self.dataPogoda.forecastOnTenDay objectAtIndex:index];
        cell.temperaturaDay.text=[day.tempday stringByAppendingString:@"°"];
        cell.temperaturaNigth.text=[day.tempnigth stringByAppendingString:@"°"];
       // NSLog(@"%@",day.cloudImageURL);
        NSString * cloudImage=[self.baseURL stringByAppendingString: day.cloudImageURL];
        NSString * tempstr=[self foungImageClouding:cloudImage];
       // NSData * imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:cloudImage]];
       // UIImage * image=[UIImage imageWithData:imageData];
        UIImage * image=[UIImage imageNamed:tempstr];
        cell.imagePogoda.image=image;
    }
    if (indexPath.row%2==0)
    {
        UIColor * colorCell=[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:alfa];
        cell.fonCell.backgroundColor=colorCell;
        cell.imagePogoda.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:alfa/2];
    }else{
        UIColor * colorCell=[UIColor colorWithRed:1 green:1 blue:1 alpha:alfa];
        cell.fonCell.backgroundColor=colorCell;
        cell.imagePogoda.backgroundColor=[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:alfa/2];
    }
    
   return cell;
}


-(NSString * ) foungImageClouding:(NSString *) str
{
    //NSLog(@"%@",str);
    NSRange range;
    if([str rangeOfString:@"cur_weather/"].location<1000){
        range.location=[str rangeOfString:@"cur_"].location+12;
        range.length=[str rangeOfString:@".png"].location-range.location;
    }
    else
    {
        range.location=[str rangeOfString:@"small"].location+5;
        range.length=[str rangeOfString:@".png"].location-range.location;
    }
    NSString * stringTemp=[str substringWithRange:range];
   // NSLog(@"%@",stringTemp);
    NSString * result=@"";
    int number=[stringTemp intValue];
    switch (number) {
        case 1: result=@"sun-128.png"; break;
        case 2: result=@"partly_cloudy_day-128.png"; break;
        case 3: result=@"partly_cloudy_day-128.png"; break;
        case 4: result=@"partly_cloudy_rain-128.png"; break;
        case 5: result=@"partly_cloudy_rain-128.png"; break;
        case 6: result=@"partly_cloudy_rain-128.png"; break;
        case 7: result=@"storm-128.png"; break;
        case 8: result=@"clouds-128.png"; break;
        case 9: result=@"little_rain-128.png"; break;
        case 10: result=@"little_rain-128.png"; break;
        case 11: result=@"little_rain-128.png"; break;
        case 12: result=@"downpour-128.png"; break;
        case 13: result=@"rain-128.png"; break;
        case 14: result=@"rain-128.png"; break;
        case 15: result=@"storm-128.png"; break;
        case 16: result=@"clouds-128.png"; break;
        case 17: result=@"partly_cloudy_day-128.png"; break;
        case 18: result=@"partly_cloudy_day-128.png"; break;
        case 19: result=@"clouds-128.png	"; break;
        case 20: result=@"sun-128.png"; break;
        default: break;
    }
    //NSLog(@"%@",result);
    return result;
}

-(void) degradationController:(float) coordY
{
    //NSLog(@"%f",coordY);
    CGRect frame=self.degradationWallpaper.frame;
    if(coordY>screenHeigth) coordY=screenHeigth;
    frame.size.height=coordY;
    frame.size.width=320;
    frame.origin.x=0;
    frame.origin.y=abs(screenHeigth-coordY);
    NSLog(@"%f",frame.origin.y);
    self.degradationWallpaper.frame=frame;
}

@end
