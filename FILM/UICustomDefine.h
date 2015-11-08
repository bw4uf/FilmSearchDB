//
//  UICustomDefine.h
//  FILM
//
//  Created by helicopter on 15/11/6.
//  Copyright © 2015年 helicopter. All rights reserved.
//

#ifndef UICustomDefine_h
#define UICustomDefine_h

//自定义 NSLog
#ifdef DEBUG
#define NSLog              NSLog(@"[%s] [%s] [%d]",strrchr(__FILE__,'/'),__FUNCTION__,__LINE__);NSLog
#else
#define NSLog(...)
#endif

#endif /* UICustomDefine_h */
