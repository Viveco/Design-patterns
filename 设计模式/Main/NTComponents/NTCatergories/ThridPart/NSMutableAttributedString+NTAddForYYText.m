//
//  NSMutableAttributedString+NTAddForYYText.m
//  NTProject
//
//  Created by 肖文 on 2017/10/12.
//  Copyright © 2017年 NineTonTech. All rights reserved.
//

#import "NSMutableAttributedString+NTAddForYYText.h"
#import "UIImage+NTAdd.h"

#import <YYText/YYText.h>

@implementation NSMutableAttributedString (NTAddForYYText)
- (void)nt_yyAppendSpaccing:(float)spacing{
    [self appendAttributedString:[NSAttributedString yy_attachmentStringWithContent:[UIImage nt_imageWithColor:[UIColor clearColor]] contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(spacing, 1) alignToFont:[UIFont systemFontOfSize:1] alignment:YYTextVerticalAlignmentCenter]];
}
@end
