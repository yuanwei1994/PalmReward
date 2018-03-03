//
//  PRConfig.h
//  PalmReward
//
//  Created by rimi on 16/12/22.
//  Copyright © 2016年 zjy. All rights reserved.
//

#ifndef PRConfig_h
#define PRConfig_h

#define RANDOMCOLOR [UIColor colorWithRed:arc4random()%255/256.f green:arc4random()%255/256.f blue:arc4random()%255/256.f alpha:1]
#define COLOR_RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define COVERVIEW_BACKGROUND  COLOR_RGB(52, 52, 52, 1)
#define APP_MAIN_COLOR COLOR_RGB(239, 234, 218, 1)


#if DEBUG
#define PRLog(format, ...)       NSLog(format, ##__VA_ARGS__)
#else
#define PRLog(format, ...)
#endif


#endif /* PRConfig_h */
