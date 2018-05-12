//
//  NSMutableAttributedString+NTAddForYYText.h
//  NTProject
//
//  Created by 肖文 on 2017/10/12.
//  Copyright © 2017年 NineTonTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (NTAddForYYText)
/**
 为用于YYTextLayout的NSMutableAttributedString便捷的添加间距

 @param spacing 间距值
 */
- (void)nt_yyAppendSpaccing:(float)spacing;
@end
