//
//  ColorHeader.h
//  xiaofeibao
//
//  Created by Xiao_huanG on 15/8/27.
//  Copyright (c) 2015年 Xiao_huanG. All rights reserved.
//

#ifndef xiaofeibao_ColorHeader_h
#define xiaofeibao_ColorHeader_h

#define COLOR_VALUE(r,g,b,a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:a]
#define ColorHexValue(value) [UIColor colorWithRed:((float)((r & 0xFF0000) >> 16)) / 255.0 green:((float)((r & 0xFF00) >> 8)) / 255.0 blue:((float)(r & 0xFF)) / 255.0 alpha:a]

//#define BACKGROUND_COLOR        COLOR_VALUE(246, 255, 240, 1)
//#define NAV_BAR_COLOR           COLOR_VALUE(255, 52, 0, 1)
//#define FONT_SELECTED_COLOR     COLOR_VALUE(255, 52, 0, 1)
//#define FONT_NORMAL_COLOR       COLOR_VALUE(128, 128, 128, 1)
//#define IMAGE_BG_COLOR          COLOR_VALUE(188, 188, 188, 1)

#define kMsg_Color               COLOR_VALUE(81,81,81,1)

#endif
