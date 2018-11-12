//
//  MacroDefine.h
//  Shine
//
//  Created by oops on 2018/10/31.
//  Copyright © 2018 oops. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

//屏幕宽度
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
//安全区域
#define SafeAreaTopHeight (ScreenWidth >= 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (ScreenHeight >= 812.0 ? 34 : 0)

//主屏幕
#define KeyWindow [UIApplication sharedApplication].keyWindow


#endif /* MacroDefine_h */
