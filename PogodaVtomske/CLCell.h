//
//  CLCell.h
//  PogodaVtomske
//
//  Created by Администратор on 8/17/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *denNedeli;
@property (weak, nonatomic) IBOutlet UILabel *temperaturaDay;
@property (weak, nonatomic) IBOutlet UILabel *temperaturaNigth;
@property (weak, nonatomic) IBOutlet UIImageView *imagePogoda;
@property (weak, nonatomic) IBOutlet UIImageView *fonCell;

@end
