//
//  HWView.h
//  HWDemo
//
//  Created by hw on 2017/5/17.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWView : UIView
/**  */
@property(nonatomic,assign) NSInteger type;
- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type;
@end
