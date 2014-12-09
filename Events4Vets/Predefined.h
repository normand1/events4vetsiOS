//
//  Predefined.h
//  Events4Vets
//
//  Created by davinorm on 10/26/14.
//  Copyright (c) 2014 David Norman. All rights reserved.
//

#ifndef Events4Vets_Predefined_h
#define Events4Vets_Predefined_h

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define KdeviceType = [UIDevice currentDevice].model;
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kCurrentDevice ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? @"Main_iPad": @"Main_iPhone")
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))
#define KbarHeight [kCurrentDevice isEqualToString:@"Main_iPad"]?50.f:30.f
#define kFinishedTutorial @"kFinishedTutorial"

#endif
