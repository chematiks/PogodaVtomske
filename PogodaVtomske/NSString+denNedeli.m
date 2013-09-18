//
//  NSString+denNedeli.m
//  PogodaVtomske
//
//  Created by Администратор on 8/17/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "NSString+denNedeli.h"

@implementation NSString (denNedeli)

-(NSString *) denNedeli:(NSInteger ) nomer
{
    NSInteger index=nomer%7;
    NSString * str=@"hz";
    if (index==2) {str=@"Понедельник";}
    if (index==3) {str=@"Вторник";}
    if (index==4) {str=@"Среда";}
    if (index==5) {str=@"Четверг";}
    if (index==6) {str=@"Пятница";}
    if (index==0) {str=@"Суббота";}
    if (index==1) {str=@"Воскресение";}
    return str;
}

@end
